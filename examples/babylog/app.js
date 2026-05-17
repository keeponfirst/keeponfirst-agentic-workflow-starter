document.addEventListener('DOMContentLoaded', () => {
    updateTime();
    setInterval(updateTime, 60000);

    const buttons = document.querySelectorAll('.action-card');
    const logList = document.getElementById('log-list');

    buttons.forEach(btn => {
        btn.addEventListener('click', () => {
            const label = btn.querySelector('.action-label').innerText;
            const iconClass = btn.querySelector('.icon-circle').className;
            const iconContent = btn.querySelector('.icon-circle').innerHTML;
            const style = btn.querySelector('.icon-circle').getAttribute('style') || '';
            const computedStyle = window.getComputedStyle(btn.querySelector('.icon-circle'));
            const bg = computedStyle.backgroundColor;
            const color = computedStyle.color;

            addLogItem(label, iconContent, bg, color);

            if (navigator.vibrate) navigator.vibrate(10);
        });
    });

    function updateTime() {
        // Clock logic can go here
    }

    function addLogItem(title, icon, bg, color) {
        const now = new Date();
        const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        const li = document.createElement('div');
        li.className = 'log-item animate-pop';
        li.innerHTML = `
            <div class="icon-circle" style="width: 40px; height: 40px; font-size: 18px; background-color: ${bg}; color: ${color};">
                ${icon}
            </div>
            <div class="log-details">
                <div class="log-title">${title}</div>
                <div class="log-time">Just now • ${timeString}</div>
            </div>
        `;
        logList.insertBefore(li, logList.firstChild);
    }
});
