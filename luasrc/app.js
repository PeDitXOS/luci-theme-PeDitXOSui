/**
 * PeDitXOSui Theme - Main JavaScript
 * Version: 1.0.0
 */

(function() {
    'use strict';

    // DOM Ready
    document.addEventListener('DOMContentLoaded', function() {
        initNavbar();
        initTheme();
        initAnimations();
    });

    /**
     * Initialize Navbar functionality
     */
    function initNavbar() {
        const toggler = document.querySelector('.toggler');
        const navbar = document.querySelector('.peeditxos-navbar');

        if (toggler && navbar) {
            toggler.addEventListener('click', function(e) {
                e.preventDefault();
                navbar.classList.toggle('active');
            });
        }

        // Handle navbar item clicks
        const navbarItems = document.querySelectorAll('.peeditxos-navbar-item');
        navbarItems.forEach(function(item) {
            item.addEventListener('click', function() {
                navbarItems.forEach(function(i) { i.classList.remove('active'); });
                this.classList.add('active');
            });
        });
    }

    /**
     * Initialize Theme (Dark/Light)
     */
    function initTheme() {
        const savedTheme = localStorage.getItem('peeditxos-theme') || 'dark';
        document.documentElement.setAttribute('data-theme', savedTheme);
    }

    /**
     * Initialize Animations
     */
    function initAnimations() {
        // Intersection Observer for fade-in animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('peeditxos-animate-fade');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observe cards and modules
        document.querySelectorAll('.peeditxos-card, .peeditxos-module').forEach(function(el) {
            observer.observe(el);
        });
    }

    /**
     * Utility: Debounce
     */
    function debounce(func, wait) {
        let timeout;
        return function executedFunction() {
            const context = this;
            const args = arguments;
            clearTimeout(timeout);
            timeout = setTimeout(function() {
                func.apply(context, args);
            }, wait);
        };
    }

    /**
     * Utility: Format bytes
     */
    function formatBytes(bytes, decimals) {
        if (bytes === 0) return '0 Bytes';
        decimals = decimals || 2;
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(decimals)) + ' ' + sizes[i];
    }

    /**
     * Utility: Format speed (Mbps)
     */
    function formatSpeed(mbps) {
        if (mbps >= 1000) {
            return (mbps / 1000).toFixed(1) + ' Gbps';
        }
        return mbps.toFixed(1) + ' Mbps';
    }

    /**
     * Utility: Time ago
     */
    function timeAgo(date) {
        const seconds = Math.floor((new Date() - date) / 1000);
        const intervals = {
            year: 31536000,
            month: 2592000,
            week: 604800,
            day: 86400,
            hour: 3600,
            minute: 60
        };

        for (const [unit, value] of Object.entries(intervals)) {
            const interval = Math.floor(seconds / value);
            if (interval >= 1) {
                return interval + ' ' + unit + (interval > 1 ? 's' : '') + ' ago';
            }
        }
        return 'just now';
    }

    // Export utilities
    window.PeDitXOSui = {
        debounce: debounce,
        formatBytes: formatBytes,
        formatSpeed: formatSpeed,
        timeAgo: timeAgo
    };

})();
