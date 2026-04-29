// ─── Image Preloading Logic ───
const preloadImages = () => {
    // Only wait for critical images to speed up initial load
    const images = Array.from(document.querySelectorAll('img[data-critical="true"]'));
    let loadedCount = 0;
    const totalMedia = images.length;
    const loadingBar = document.getElementById('loadingBar');
    const loadingOverlay = document.getElementById('loadingOverlay');
    const loadingText = document.getElementById('loadingText');

    const finishLoading = () => {
        if (loadingOverlay && !loadingOverlay.classList.contains('fade-out')) {
            loadingOverlay.classList.add('fade-out');
            ScrollTrigger.refresh();
        }
    };

    // Safety timeout: don't wait more than 5 seconds
    const timeout = setTimeout(finishLoading, 5000);

    if (totalMedia === 0) {
        finishLoading();
        clearTimeout(timeout);
        return;
    }

    const updateProgress = () => {
        loadedCount++;
        const progress = Math.round((loadedCount / totalMedia) * 100);
        if (loadingBar) loadingBar.style.width = `${progress}%`;
        if (loadingText) loadingText.innerText = `Initializing Experience... ${progress}%`;

        if (loadedCount >= totalMedia) {
            clearTimeout(timeout);
            setTimeout(finishLoading, 500);
        }
    };

    images.forEach(img => {
        if (img.complete) updateProgress();
        else { 
            img.onload = updateProgress; 
            img.onerror = updateProgress; 
        }
    });
};

window.addEventListener('load', () => {
    preloadImages();
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
});

// ─── GSAP & Lenis Initialization ───
gsap.registerPlugin(ScrollTrigger);

const lenis = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    smoothWheel: true,
    wheelMultiplier: 1.2,
    touchMultiplier: 2.0,
});

lenis.on('scroll', ScrollTrigger.update);
gsap.ticker.add((time) => lenis.raf(time * 1000));
gsap.ticker.lagSmoothing(0);

// ─── Global Elements ───
const progressBar = document.getElementById('progressBar');

// ─── Progress Bar Logic ───
gsap.to(progressBar, {
    width: '100%',
    ease: 'none',
    scrollTrigger: {
        trigger: 'body',
        start: 'top top',
        end: 'bottom bottom',
        scrub: 0.3
    }
});

// ─── Slide Entrance Animations ───
const slides = gsap.utils.toArray('.slide');
slides.forEach((slide, i) => {
    // Basic fade/up for every slide
    const content = slide.querySelector('.content-grid, .full-content');
    if (content) {
        gsap.from(content, {
            y: 50,
            opacity: 0,
            duration: 1,
            ease: 'power3.out',
            scrollTrigger: {
                trigger: slide,
                start: 'top 80%',
                toggleActions: 'play none none reverse'
            }
        });
    }

    // Special handling for Slide 3 (Automatic Storyboard Carousel)
    const cycleCard = slide.querySelector('.cycle-card');
    if (cycleCard) {
        const cycleItems = slide.querySelectorAll('.cycle-item');
        const dotsContainer = document.getElementById('cycleDots');
        let currentIndex = 0;
        let autoPlayInterval;

        // Create dots
        cycleItems.forEach((_, idx) => {
            const dot = document.createElement('div');
            dot.classList.add('cycle-dot');
            if (idx === 0) dot.classList.add('active');
            dot.addEventListener('click', () => {
                if (idx !== currentIndex) {
                    showSlide(idx, idx > currentIndex ? 1 : -1);
                }
            });
            dotsContainer.appendChild(dot);
        });

        const updateDots = () => {
            const dots = dotsContainer.querySelectorAll('.cycle-dot');
            dots.forEach((dot, idx) => {
                dot.classList.toggle('active', idx === currentIndex);
            });
        };

        const showSlide = (index, direction = 1) => {
            const currentItem = cycleItems[currentIndex];
            const nextItem = cycleItems[index];

            gsap.to(currentItem, { 
                opacity: 0, 
                y: -20 * direction, 
                duration: 0.4, 
                onComplete: () => {
                    currentItem.style.visibility = 'hidden';
                }
            });

            gsap.fromTo(nextItem, 
                { opacity: 0, y: 20 * direction, visibility: 'visible' },
                { opacity: 1, y: 0, duration: 0.4 }
            );

            currentIndex = index;
            updateDots();
        };

        const nextSlide = () => {
            let nextIndex = (currentIndex + 1) % cycleItems.length;
            showSlide(nextIndex, 1);
        };

        const prevSlide = () => {
            let prevIndex = (currentIndex - 1 + cycleItems.length) % cycleItems.length;
            showSlide(prevIndex, -1);
        };

        const stopAutoPlay = () => {
            if (autoPlayInterval) clearInterval(autoPlayInterval);
        };

        // Manual Controls
        const btnNext = document.getElementById('cycleNext');
        const btnPrev = document.getElementById('cyclePrev');

        if (btnNext) btnNext.addEventListener('click', () => {
            nextSlide();
        });

        if (btnPrev) btnPrev.addEventListener('click', () => {
            prevSlide();
        });

        // Initialize (Auto-play disabled)
        // stopAutoPlay(); // Ensure any residual is cleared if needed, but not starting it is enough.
    }

});

// ─── Image Interaction (Lightbox) ───
const lightbox = document.getElementById('lightbox'), lightboxImg = document.getElementById('lightboxImg'), closeLightboxBtn = document.getElementById('closeLightbox');

const initLightbox = () => {
    document.querySelectorAll('.image-container img, .storyboard-item img').forEach(img => {
        img.addEventListener('click', () => {
            lightboxImg.src = img.src;
            lightbox.classList.add('active');
            lenis.stop();
        });
    });
};

initLightbox();

const hideLightbox = () => { lightbox.classList.remove('active'); lenis.start(); };
if (closeLightboxBtn) closeLightboxBtn.addEventListener('click', hideLightbox);
if (lightbox) lightbox.addEventListener('click', (e) => { if (e.target === lightbox) hideLightbox(); });
