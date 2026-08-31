/**
 * PeDitXOSui Dashboard JavaScript
 * Handles traffic chart, real-time updates, and interactive elements
 */

(function() {
    'use strict';

    // Traffic Chart
    function initTrafficChart() {
        const canvas = document.getElementById('trafficChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        const container = canvas.parentElement;

        function resize() {
            canvas.width = container.offsetWidth;
            canvas.height = container.offsetHeight;
        }

        resize();
        window.addEventListener('resize', resize);

        // Data points
        const points = 100;
        let downloadData = [];
        let uploadData = [];

        // Initialize with random data
        for (let i = 0; i < points; i++) {
            downloadData.push(Math.random() * 50 + 20);
            uploadData.push(Math.random() * 30 + 10);
        }

        function getThemeColors() {
            const style = getComputedStyle(document.documentElement);
            return {
                text: style.getPropertyValue('--text-muted').trim() || '#64748b',
                border: style.getPropertyValue('--border-color').trim() || 'rgba(255,255,255,0.1)',
                accent: style.getPropertyValue('--accent-primary').trim() || '#06b6d4',
                secondary: style.getPropertyValue('--accent-secondary').trim() || '#8b5cf6'
            };
        }

        function drawChart() {
            const width = canvas.width;
            const height = canvas.height;
            const padding = 30;
            const colors = getThemeColors();

            ctx.clearRect(0, 0, width, height);

            // Draw grid
            ctx.strokeStyle = colors.border;
            ctx.lineWidth = 1;

            for (let i = 0; i <= 5; i++) {
                const y = padding + (i / 5) * (height - padding * 2);
                ctx.beginPath();
                ctx.moveTo(padding, y);
                ctx.lineTo(width - padding, y);
                ctx.stroke();

                // Y-axis labels
                ctx.fillStyle = colors.text;
                ctx.font = '10px Inter';
                ctx.fillText(Math.round((5 - i) * 20) + ' Mbps', 0, y + 3);
            }

            // Draw download line
            drawLine(ctx, downloadData, width, height, padding, colors.accent, colors.accent + '33');

            // Draw upload line
            drawLine(ctx, uploadData, width, height, padding, colors.secondary, colors.secondary + '33');
        }

        function drawLine(ctx, data, width, height, padding, color, fillColor) {
            const step = (width - padding * 2) / (data.length - 1);

            ctx.beginPath();
            ctx.strokeStyle = color;
            ctx.lineWidth = 2;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';

            data.forEach((value, i) => {
                const x = padding + i * step;
                const y = height - padding - (value / 100) * (height - padding * 2);
                if (i === 0) ctx.moveTo(x, y);
                else ctx.lineTo(x, y);
            });

            ctx.stroke();

            // Fill gradient
            ctx.lineTo(width - padding, height - padding);
            ctx.lineTo(padding, height - padding);
            ctx.closePath();

            const gradient = ctx.createLinearGradient(0, 0, 0, height);
            gradient.addColorStop(0, fillColor);
            gradient.addColorStop(1, 'transparent');
            ctx.fillStyle = gradient;
            ctx.fill();
        }

        function updateData() {
            // Add new point and remove oldest
            downloadData.shift();
            downloadData.push(Math.random() * 50 + 20);

            uploadData.shift();
            uploadData.push(Math.random() * 30 + 10);

            drawChart();
        }

        // Initial draw
        drawChart();

        // Update every 2 seconds
        setInterval(updateData, 2000);
    }

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        initTrafficChart();

        // Animate status circle
        const progressCircle = document.querySelector('.peeditxos-status-circle .progress');
        if (progressCircle) {
            const circumference = 2 * Math.PI * 70; // radius = 70
            progressCircle.style.strokeDasharray = circumference;
            progressCircle.style.strokeDashoffset = circumference;

            // Animate to 75% (or use actual CPU usage)
            setTimeout(() => {
                const offset = circumference * 0.25; // 75% fill
                progressCircle.style.strokeDashoffset = offset;
            }, 500);
        }

        // Auto-refresh log
        const logContainer = document.getElementById('systemLog');
        if (logContainer) {
            setInterval(() => {
                // Could add AJAX call to refresh log here
                console.log('Log refresh would happen here');
            }, 30000);
        }
    });

})();
