const root = document.documentElement;
const navToggle = document.querySelector(".nav-toggle");
const siteNav = document.querySelector(".site-nav");
const copyTriggers = document.querySelectorAll("[data-copy]");
const toast = document.querySelector(".toast");
const yearNode = document.querySelector("[data-year]");
const revealNodes = document.querySelectorAll("[data-reveal]");
const floatingBar = document.querySelector(".floating-bar");
const languageButtons = document.querySelectorAll("[data-lang-switch]");
const metaDescription = document.querySelector('meta[name="description"]');
const ogTitle = document.querySelector('meta[property="og:title"]');
const ogDescription = document.querySelector('meta[property="og:description"]');
const twitterTitle = document.querySelector('meta[name="twitter:title"]');
const twitterDescription = document.querySelector('meta[name="twitter:description"]');
const hasLanguageVariants =
  languageButtons.length > 0 &&
  Boolean(document.querySelector(".lang-zh")) &&
  Boolean(document.querySelector(".lang-en"));

const copyMessages = {
  zh: "已复制：",
  en: "Copied: "
};

const metaByLanguage = {
  zh: {
    lang: "zh-CN",
    title: "张兆新律师 | 深圳涉外争议、TRO诉讼、涉外知产与美国诉讼仲裁律师 | 天册律师事务所",
    description:
      "张兆新律师，天册律师事务所深圳办公室合伙人，中国及美国加州执业律师，聚焦跨境争议、TRO诉讼、涉外知识产权、美国诉讼仲裁、跨境电商与交易合规。公开内容矩阵涵盖官网、TRO稻草人公众号、小红书和 TROTracker 工具。",
    ogTitle: "张兆新律师 | 深圳涉外争议、TRO诉讼、涉外知产与美国诉讼仲裁律师",
    ogDescription:
      "天册律师事务所深圳办公室合伙人，中国及美国加州执业律师。聚焦跨境争议、TRO诉讼、涉外知识产权、美国诉讼仲裁、跨境电商与交易合规。"
  },
  en: {
    lang: "en",
    title: "Zhaoxin Zhang | Shenzhen Cross-Border Disputes, TRO Litigation, Foreign-Related IP and U.S. Litigation / Arbitration Counsel",
    description:
      "Zhaoxin Zhang is a partner at the Shenzhen office of T&C Law Firm, admitted in both China and California, with public practice areas spanning cross-border disputes, TRO litigation, foreign-related IP, U.S. litigation / arbitration, e-commerce and compliance.",
    ogTitle: "Zhaoxin Zhang | Cross-Border Disputes, TRO Litigation, Foreign-Related IP and U.S. Litigation / Arbitration Counsel",
    ogDescription:
      "Public site for Zhaoxin Zhang covering cross-border disputes, TRO litigation, foreign-related IP, U.S. litigation / arbitration, e-commerce and compliance."
  }
};

function getCurrentLanguage() {
  return root.dataset.lang === "en" ? "en" : "zh";
}

function applyLanguage(language) {
  const nextLanguage = language === "en" ? "en" : "zh";
  const meta = metaByLanguage[nextLanguage];

  root.dataset.lang = nextLanguage;
  root.lang = meta.lang;
  document.title = meta.title;

  if (metaDescription) metaDescription.setAttribute("content", meta.description);
  if (ogTitle) ogTitle.setAttribute("content", meta.ogTitle);
  if (ogDescription) ogDescription.setAttribute("content", meta.ogDescription);
  if (twitterTitle) twitterTitle.setAttribute("content", meta.ogTitle);
  if (twitterDescription) twitterDescription.setAttribute("content", meta.ogDescription);

  languageButtons.forEach((button) => {
    const isActive = button.getAttribute("data-lang-switch") === nextLanguage;
    button.classList.toggle("is-active", isActive);
    button.setAttribute("aria-pressed", String(isActive));
  });

  try {
    const url = new URL(window.location.href);
    if (nextLanguage === "en") {
      url.searchParams.set("lang", "en");
    } else {
      url.searchParams.delete("lang");
    }
    window.history.replaceState({}, "", url);
  } catch (error) {
    // Ignore URL update failures in embedded browsers.
  }

  try {
    window.localStorage.setItem("zx-site-language", nextLanguage);
  } catch (error) {
    // Ignore storage failures in private mode or embedded browsers.
  }

  updateNavToggleLabel(siteNav ? siteNav.classList.contains("is-open") : false);
}

function updateNavToggleLabel(isOpen) {
  if (!navToggle) return;

  const language = getCurrentLanguage();
  const label =
    language === "en"
      ? isOpen
        ? "Close navigation menu"
        : "Open navigation menu"
      : isOpen
        ? "关闭导航菜单"
        : "打开导航菜单";

  navToggle.setAttribute("aria-label", label);
  navToggle.setAttribute("aria-haspopup", "true");
}

if (yearNode) {
  yearNode.textContent = new Date().getFullYear();
}

if (hasLanguageVariants) {
  try {
    const languageFromQuery = new URLSearchParams(window.location.search).get("lang");
    const storedLanguage = window.localStorage.getItem("zx-site-language");
    if (languageFromQuery === "zh" || languageFromQuery === "en") {
      applyLanguage(languageFromQuery);
    } else if (storedLanguage === "zh" || storedLanguage === "en") {
      applyLanguage(storedLanguage);
    } else {
      applyLanguage("zh");
    }
  } catch (error) {
    applyLanguage("zh");
  }
}

languageButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const nextLanguage = button.getAttribute("data-lang-switch");
    applyLanguage(nextLanguage);
  });
});

if (navToggle && siteNav) {
  updateNavToggleLabel(false);

  navToggle.addEventListener("click", () => {
    const isOpen = siteNav.classList.toggle("is-open");
    navToggle.setAttribute("aria-expanded", String(isOpen));
    updateNavToggleLabel(isOpen);
  });

  siteNav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      siteNav.classList.remove("is-open");
      navToggle.setAttribute("aria-expanded", "false");
      updateNavToggleLabel(false);
    });
  });
}

function showToast(message) {
  if (!toast) return;
  toast.textContent = message;
  toast.classList.add("is-visible");
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => {
    toast.classList.remove("is-visible");
  }, 2200);
}

async function copyText(value) {
  const prefix = copyMessages[getCurrentLanguage()];

  try {
    await navigator.clipboard.writeText(value);
    showToast(`${prefix}${value}`);
  } catch (error) {
    const input = document.createElement("input");
    input.value = value;
    document.body.appendChild(input);
    input.select();
    document.execCommand("copy");
    input.remove();
    showToast(`${prefix}${value}`);
  }
}

copyTriggers.forEach((trigger) => {
  trigger.addEventListener("click", () => {
    const value = trigger.getAttribute("data-copy");
    if (value) copyText(value);
  });
});

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add("is-visible");
      observer.unobserve(entry.target);
    });
  },
  {
    threshold: 0.18,
    rootMargin: "0px 0px -40px 0px"
  }
);

revealNodes.forEach((node) => observer.observe(node));

function updateFloatingBar() {
  if (!floatingBar) return;
  floatingBar.classList.toggle("is-active", window.scrollY > 260);
}

updateFloatingBar();
window.addEventListener("scroll", updateFloatingBar, { passive: true });
