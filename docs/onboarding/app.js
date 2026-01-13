document.addEventListener('DOMContentLoaded', () => {
    const steps = document.querySelectorAll('.step');
    const nextBtn = document.getElementById('nextBtn');
    const prevBtn = document.getElementById('prevBtn');
    const dots = document.querySelectorAll('.dot');
    const ctaButton = document.querySelector('.cta-button');
    const navButtons = document.querySelector('.navigation-buttons');

    let currentStep = 1;

    const updateStep = (newStep) => {
        // Find current active step and remove active class
        const currentActiveStep = document.querySelector('.step.active');
        if (currentActiveStep) {
            currentActiveStep.classList.remove('active');
        }

        // Add active class to the new step
        const newStepElement = document.querySelector(`.step[data-step="${newStep}"]`);
        if (newStepElement) {
            newStepElement.classList.add('active');
        }

        // Update dots
        dots.forEach(dot => {
            dot.classList.remove('active');
            if (parseInt(dot.dataset.step) === newStep) {
                dot.classList.add('active');
            }
        });

        // Update button states
        prevBtn.disabled = newStep === 1;
        
        if (newStep === steps.length) {
            nextBtn.style.display = 'none';
            navButtons.style.display = 'none';
            ctaButton.style.display = 'block';
        } else {
            nextBtn.textContent = '下一步';
            nextBtn.style.display = 'block';
            navButtons.style.display = 'flex';
            ctaButton.style.display = 'none';
        }
        
        currentStep = newStep;
    };

    nextBtn.addEventListener('click', () => {
        if (currentStep < steps.length) {
            updateStep(currentStep + 1);
        }
    });

    prevBtn.addEventListener('click', () => {
        if (currentStep > 1) {
            updateStep(currentStep - 1);
        }
    });

    // Initialize the first step
    updateStep(1);
});
