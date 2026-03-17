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
    
    // Get form data
    const formData = new FormData(contactForm);
    const action = contactForm.getAttribute('action');

    try {
      // Show loading state
      btn.innerHTML = `<span>Sending...</span>`;
      btn.disabled = true;

      const response = await fetch(action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      });

      if (response.ok) {
        btn.innerHTML = `<span>Message Sent! ✓</span>`;
        btn.style.background = 'linear-gradient(135deg, #00d4aa, #00b894)';
        contactForm.reset();
      } else {
        throw new Error('Form submission failed');
      }
    } catch (error) {
      btn.innerHTML = `<span>Error! Try again.</span>`;
      btn.style.background = 'linear-gradient(135deg, #ff4757, #ff6b81)';
      btn.disabled = false;
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

  // Tilt effect removed — unnecessary motion can cause accessibility
  // issues and cognitive overload. Content speaks for itself.

});
