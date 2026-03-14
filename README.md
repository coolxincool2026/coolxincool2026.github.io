# 张兆新律师个人网站

张兆新律师，天册律师事务所深圳办公室合伙人，中国及美国加州执业律师。公开业务方向聚焦跨境争议、TRO、TRO诉讼、涉外知识产权、美国诉讼仲裁、跨境电商、知识产权与交易合规。

这个仓库对应的正式公开站点是：

- 个人网站: `https://coolxincool2026.github.io`
- TROTracker: `https://www.trotracker.com`
- TRO 稻草人内容矩阵页: `https://coolxincool2026.github.io/tro-daocaoren.html`

当前站点已经扩展为多页面静态站，包含首页、个人资料页、业务导航页、TRO 专题、TRO诉讼专题、涉外知识产权专题、美国诉讼仲裁专题、跨境争议专题、跨境电商法律顾问专题、工具型查询指南，以及 `sitemap.xml`、`robots.txt`、`llms.txt`、`llms-full.txt`、`feed.xml`。

## 对外定位

- 张兆新律师个人品牌主站
- TRO 稻草人内容矩阵公开入口
- TROTracker / TRO 稻草人 Docket 的辅助说明与导流入口

## 公开可读入口

- 官网首页: `https://coolxincool2026.github.io/`
- 个人资料页: `https://coolxincool2026.github.io/zhang-zhaoxin-profile.html`
- English Profile: `https://coolxincool2026.github.io/zhaoxin-zhang-profile-en.html`
- 业务导航页: `https://coolxincool2026.github.io/zhang-zhaoxin-service-guide.html`
- RSS 订阅: `https://coolxincool2026.github.io/feed.xml`
- TRO诉讼专题: `https://coolxincool2026.github.io/tro-litigation-lawyer-shenzhen.html`
- 涉外知识产权专题: `https://coolxincool2026.github.io/foreign-related-ip-lawyer-shenzhen.html`
- 美国诉讼仲裁专题: `https://coolxincool2026.github.io/us-litigation-arbitration-lawyer-shenzhen.html`
- TROTracker 工具介绍页: `https://coolxincool2026.github.io/trotracker.html`
- TRO 案件查询指南: `https://coolxincool2026.github.io/tro-case-search-guide.html`
- Schedule A 案件查询指南: `https://coolxincool2026.github.io/schedule-a-case-search-guide.html`
- 品牌查询指南: `https://coolxincool2026.github.io/brand-tro-case-search-guide.html`
- 律所查询指南: `https://coolxincool2026.github.io/law-firm-tro-case-search-guide.html`
- Docket 时间线指南: `https://coolxincool2026.github.io/docket-timeline-reading-guide.html`

## 本地预览

在当前目录执行：

```bash
python3 -m http.server 4173
```

然后访问 `http://localhost:4173`。

## 目录结构

- `index.html`: 页面结构与 SEO 元信息
- `styles.css`: 视觉样式与响应式布局
- `script.js`: 复制微信、滚动显现、移动端导航
- `assets/`: 头像、favicon、社交分享图

## 当前线上地址

- 正式访问地址：`https://coolxincool2026.github.io`
- 仓库地址：`https://github.com/coolxincool2026/coolxincool2026.github.io`

说明：

- 当前正式版已经切到 GitHub Pages，可正常被抓取
- `*.surge.sh` 子域名当前实际返回的平台级 `robots.txt` 为 `Disallow: /`
- 因此旧 Surge 地址只适合作为历史预览，不适合作为最终 SEO 域名

## 重新发布 GitHub Pages 正式版

后续如果你修改了页面内容，建议优先用脚本重新发布：

```bash
./scripts/publish-github-pages.sh /path/to/coolxincool2026.github.io
```

如果你手里没有本地仓库副本，也可以直接传仓库地址：

```bash
./scripts/publish-github-pages.sh https://github.com/coolxincool2026/coolxincool2026.github.io.git
```

脚本内部会先同步 `dist/`，再把内容推到目标仓库。

如果你只想手动同步静态产物，再自己处理提交，也可以先执行：

```bash
rsync -a --delete --exclude 'dist' /Users/serendipitypku/Documents/Playground/zhaoxin-lawyer-site/ /Users/serendipitypku/Documents/Playground/zhaoxin-lawyer-site/dist/
```

然后把根目录静态文件重新推到 `coolxincool2026.github.io` 仓库的 `main` 分支。

## 重新发布 Surge 预览

如果只是临时给别人看，也可以继续发布到旧 Surge 预览域名，但它不适合作为正式 SEO 地址。

## 后续建议的正式 SEO 域名方案

可直接上传整个目录到静态托管平台，例如：

- Netlify
- Cloudflare Pages
- Vercel
- GitHub Pages

建议优先顺序：

1. 自定义域名 + Cloudflare Pages
2. 自定义域名 + Netlify
3. 其他不屏蔽抓取的正式域名托管

## 当前已经完成的 SEO / GEO 基础项

- 首页 `canonical`、Open Graph、Twitter Card、结构化数据
- `Person` / `LegalService` / `ProfilePage` / `FAQPage` Schema
- 多张面向搜索意图的专题页
- `sitemap.xml`
- 本地项目内 `robots.txt`
- `llms.txt` / `llms-full.txt`
- `feed.xml`
- IndexNow key file 与提交通知脚本
- FAQ、公开背书与可核验来源链接

## 当前上线后建议继续做

1. Google Search Console / Bing Webmaster 完成站点验证
2. 提交 `sitemap.xml`
3. 部署完成后运行 `scripts/submit-indexnow.sh` 向 IndexNow 提交已上线 URL
4. 继续新增专题页和案例型内容
5. 如果以后换独立域名，重新替换 `canonical`、`og:url`、`sitemap.xml`、`llms.txt`

## IndexNow 快速通知

部署完成并确认根目录的 `e634e3d6-7cdb-4d6a-99b7-bd32bf291f91.txt` 已可公开访问后，可以执行：

```bash
./scripts/submit-indexnow.sh
```

如果只想提交单个或少量新页面：

```bash
./scripts/submit-indexnow.sh https://coolxincool2026.github.io/zhang-zhaoxin-profile.html
```

## 需要替换的域名位置

如果以后切到新的正式域名，需要统一替换以下文件中的 `https://coolxincool2026.github.io`：

1. `index.html`
2. `tro-lawyer-shenzhen.html`
3. `cross-border-dispute-lawyer-shenzhen.html`
4. `cross-border-ecommerce-lawyer-shenzhen.html`
5. `sitemap.xml`
6. `llms.txt`
7. `llms-full.txt`

替换后重新同步到 `dist/` 再发布。
