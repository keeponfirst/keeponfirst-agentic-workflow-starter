const WebSocket = require('ws');
const readline = require('readline');
const { exec } = require('child_process');

function getPencilPort() {
    return new Promise((resolve, reject) => {
        // Check if port passed as arg
        if (process.argv[2]) {
            return resolve(process.argv[2]);
        }

        // Try to find running mcp-server process
        exec('ps aux | grep mcp-server-darwin-arm64', (error, stdout, stderr) => {
            if (error) {
                console.error(`[Proxy] exec error: ${error}`);
                return resolve('52142'); // Fallback to old default
            }

            // Look for --ws-port <number>
            const match = stdout.match(/--ws-port\s+(\d+)/);
            if (match && match[1]) {
                resolve(match[1]);
            } else {
                // console.error('[Proxy] Could not find running Pencil server port. Using default.');
                resolve('52142');
            }
        });
    });
}

async function main() {
    const port = await getPencilPort();
    const URL = `ws://localhost:${port}`;

    // console.error(`[Proxy] Connecting to ${URL}`);

    const ws = new WebSocket(URL);
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });

    let messageQueue = [];

    ws.on('open', () => {
        // console.error('[Proxy] Connected');
        while (messageQueue.length > 0) {
            ws.send(messageQueue.shift());
        }
    });

    ws.on('message', (data) => {
        process.stdout.write(data.toString() + '\n');
    });

    ws.on('error', (err) => {
        console.error(`[Proxy] Error connecting to ${URL}: ${err.message}`);
        process.exit(1);
    });

    ws.on('close', () => {
        process.exit(0);
    });

    rl.on('line', (line) => {
        if (line.trim()) {
            if (ws.readyState === WebSocket.OPEN) {
                ws.send(line);
            } else {
                messageQueue.push(line);
            }
        }
    });
}

main();
