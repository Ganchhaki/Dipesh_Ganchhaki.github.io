/* ============================================
   UX RESEARCHER PORTFOLIO — INTERACTIONS
   ============================================ */

document.addEventListener('DOMContentLoaded', () => {

  // --- Cursor Glow ---
  const cursorGlow = document.getElementById('cursorGlow');
  let mouseX = 0, mouseY = 0;
  let glowX = 0, glowY = 0;

  document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
  });

  function animateGlow() {
    glowX += (mouseX - glowX) * 0.08;
    glowY += (mouseY - glowY) * 0.08;
    cursorGlow.style.left = glowX + 'px';
    cursorGlow.style.top = glowY + 'px';
    requestAnimationFrame(animateGlow);
  }
  animateGlow();

  // --- Navigation scroll effect ---
  const nav = document.getElementById('nav');
  let lastScroll = 0;

  window.addEventListener('scroll', () => {
    const currentScroll = window.scrollY;
    if (currentScroll > 60) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
    lastScroll = currentScroll;
  });

  // --- Show/hide nav logo based on hero name visibility ---
  const navLogo = document.getElementById('navLogo');
  const heroName = document.getElementById('heroName');

  const heroNameObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLogo.classList.remove('visible');
      } else {
        navLogo.classList.add('visible');
      }
    });
  }, { threshold: 0.1 });

  heroNameObserver.observe(heroName);

  // --- Mobile Nav Toggle ---
  const navToggle = document.getElementById('navToggle');
  const navLinks = document.getElementById('navLinks');

  navToggle.addEventListener('click', () => {
    navToggle.classList.toggle('active');
    navLinks.classList.toggle('open');
  });

  // Close mobile nav on link click
  navLinks.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
      navToggle.classList.remove('active');
      navLinks.classList.remove('open');
    });
  });

  // --- Scroll Animations (Intersection Observer) ---
  const animatedElements = document.querySelectorAll('[data-animate]');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const delay = entry.target.dataset.delay || 0;
        setTimeout(() => {
          entry.target.classList.add('visible');
        }, parseInt(delay));
        observer.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.15,
    rootMargin: '0px 0px -40px 0px'
  });

  animatedElements.forEach(el => observer.observe(el));



  // --- Active Navigation Highlight ---
  const sections = document.querySelectorAll('.section, .hero');
  const navLinksAll = document.querySelectorAll('.nav-link');

  const sectionObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const id = entry.target.getAttribute('id');
        navLinksAll.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === `#${id}`) {
            link.classList.add('active');
          }
        });
      }
    });
  }, {
    threshold: 0.1,
    rootMargin: '-80px 0px -30% 0px'
  });

  sections.forEach(section => sectionObserver.observe(section));

  // --- Contact Form ---
  const contactForm = document.getElementById('contactForm');

  contactForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    const btn = contactForm.querySelector('.btn-primary');
    const originalHTML = btn.innerHTML;
    
    // Get form values for fallback
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const message = document.getElementById('message').value;
    const action = contactForm.getAttribute('action');

    try {
      // Show loading state
      btn.innerHTML = `<span>Sending...</span>`;
      btn.disabled = true;

      const response = await fetch(action, {
        method: 'POST',
        body: new FormData(contactForm),
        headers: {
          'Accept': 'application/json'
        }
      });

      if (response.ok) {
        btn.innerHTML = `<span>Message Sent! ✓</span>`;
        btn.style.background = 'linear-gradient(135deg, #00d4aa, #00b894)';
        contactForm.reset();
      } else {
        throw new Error('Automation failed, switching to mailto');
      }
    } catch (error) {
      // FALLBACK: Opening the system email client (Gmail app, Outlook, etc.)
      const subject = encodeURIComponent(`Portfolio Message from ${name}`);
      const body = encodeURIComponent(`${message}\n\n---\nFrom: ${name} (${email})`);
      const mailtoUrl = `mailto:gdipesh540@gmail.com?subject=${subject}&body=${body}`;
      
      // This will trigger the browser's "Choose account" behavior via their email app
      window.location.href = mailtoUrl;

      btn.innerHTML = `<span>Opening Email App...</span>`;
      btn.style.background = 'linear-gradient(135deg, #4285f4, #34a853)';
    }

    setTimeout(() => {
      btn.innerHTML = originalHTML;
      btn.style.background = '';
      btn.disabled = false;
    }, 4000);
  });

  // --- Smooth scroll for nav links ---
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  // --- Skills Accordion ---
  const skillItems = document.querySelectorAll('.skill-item');

  skillItems.forEach(item => {
    item.querySelector('.skill-header').addEventListener('click', () => {
      const isOpen = item.classList.contains('open');
      // Close all items
      skillItems.forEach(i => i.classList.remove('open'));
      // Toggle clicked item
      if (!isOpen) {
        item.classList.add('open');
      }
    });
  });

  // --- Projects Slider ---
  const projectsGrid = document.getElementById('projectsGrid');
  const prevBtn = document.getElementById('prevBtn');
  const nextBtn = document.getElementById('nextBtn');

  if (projectsGrid && prevBtn && nextBtn) {
    const getScrollAmount = () => {
      const firstCard = projectsGrid.querySelector('.project-card');
      if (firstCard) {
        // Scroll by one card width + gap
        const style = window.getComputedStyle(projectsGrid);
        const gap = parseInt(style.columnGap) || 32;
        return firstCard.offsetWidth + gap;
      }
      return 450;
    };

    nextBtn.addEventListener('click', () => {
      projectsGrid.scrollBy({
        left: getScrollAmount(),
        behavior: 'smooth'
      });
    });

    prevBtn.addEventListener('click', () => {
      projectsGrid.scrollBy({
        left: -getScrollAmount(),
        behavior: 'smooth'
      });
    });

    // Optional: Disable buttons at ends
    const toggleButtons = () => {
      const scrollLeft = projectsGrid.scrollLeft;
      const maxScroll = projectsGrid.scrollWidth - projectsGrid.clientWidth;
      
      prevBtn.style.opacity = scrollLeft <= 0 ? '0.3' : '1';
      prevBtn.style.pointerEvents = scrollLeft <= 0 ? 'none' : 'auto';
      
      nextBtn.style.opacity = scrollLeft >= maxScroll - 5 ? '0.3' : '1';
      nextBtn.style.pointerEvents = scrollLeft >= maxScroll - 5 ? 'none' : 'auto';
    };

    projectsGrid.addEventListener('scroll', toggleButtons);
    window.addEventListener('resize', toggleButtons);
    // Initial check
    setTimeout(toggleButtons, 100);
  }

  // Tilt effect removed — unnecessary motion can cause accessibility
  // issues and cognitive overload. Content speaks for itself.

});
