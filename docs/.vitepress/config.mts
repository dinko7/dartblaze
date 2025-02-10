import { defineConfig } from 'vitepress'
import { withSidebar } from 'vitepress-sidebar';

const vitePressOptions = {
  title: "Dartblaze Docs",
  description: "Dartblaze Docs",
  markdown: {
    image: {
      lazyLoading: true
    }
  },
  themeConfig: {
    logo: "/logo-centered.png",
    footer: {
      copyright: 'Copyright © 2024 Dartblaze Authors',
    },
    socialLinks: [
      {
          icon: {
              svg: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" style="fill: none;" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-globe"><circle cx="12" cy="12" r="10"/><path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/><path d="M2 12h20"/></svg>`
          },
          link: "https://discord.app"
      },
      {icon: "discord", link: "https://discord.gg/WMQbY57G"},
      {icon: "twitter", link: "https://x.com/"},
      {icon: "github", link: "https://github.com/dinko7/dartblaze"}
    ],
    homepage: '/introduction/overview',
  },
  search: {
    provider: "local"
  },
  srcDir: './docs',
  cleanUrls: true
};

const vitePressSidebarOptions = {
  documentRootPath: '/docs',
  collapsed: true,
  capitalizeFirst: true,
  includeRootIndexFile: true,
  rootGroupText: 'Documentation',
  hyphenToSpace: true,
  excludePattern: ['index.md'],
  sortFolderTo: "top",
  manualSortFileNameByPriority: ['introduction', 'functions'],
};

export default defineConfig(withSidebar(vitePressOptions, vitePressSidebarOptions));
