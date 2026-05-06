# Cloudflare Worker Token Server 部署指南

## 快速部署（5 分钟）

### 1️⃣ 获取 LiveKit API Secret

1. 访问：https://cloud.livekit.io/projects/p:livekit-cove
2. 左侧菜单：**Settings** → **API Keys**
3. 点击你的 API Key (`APIMHobLy2Nny6k`) 旁边的菜单 (⋮)
4. 选择 **Regenerate** 或 **View Secret**
5. **复制 Secret**（只显示一次，务必保存！）

---

### 2️⃣ 登录 Cloudflare

```bash
cd /Volumes/ORICO-APFS/app/20260503/Cove/cloudflare-worker
npx wrangler login
```

这会打开浏览器，登录你的 Cloudflare 账号。

---

### 3️⃣ 设置 API Secret

**方法 A：使用命令行**

```bash
npx wrangler secret put API_SECRET
```

粘贴你从 LiveKit 复制的 Secret。

**方法 B：使用 Dashboard**

1. 访问：https://dash.cloudflare.com
2. 左侧：**Workers & Pages** → **cove-token-server**
3. **Settings** → **Variables** → **Add**
4. 变量名：`API_SECRET`
5. 值：粘贴你的 Secret
6. **Save**

---

### 4️⃣ 部署 Worker

```bash
npx wrangler deploy
```

首次部署会提示：
- 确认 Worker 名称：`cove-token-server`
- 选择 Cloudflare 账号（如果有多个）

部署成功后会显示：
```
Deployed cove-token-server triggers:
  https://cove-token-server.<your-subdomain>.workers.dev
```

---

### 5️⃣ 测试 Worker

```bash
curl -X POST https://cove-token-server.<your-subdomain>.workers.dev \
  -H "Content-Type: application/json" \
  -d '{"room":"test-room","participant":"testuser"}'
```

应该返回：
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## 更新 iOS 代码

部署成功后，更新 `Cove/Cove/Services/LiveKitService.swift`：

```swift
private func generateToken(room: String, participant: String) async throws -> String {
    // 替换为你的 Worker URL
    let url = URL(string: "https://cove-token-server.your-subdomain.workers.dev")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: [
        "room": room,
        "participant": participant
    ])
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
    return tokenResponse.token
}

struct TokenResponse: Codable {
    let token: String
}
```

---

## 本地开发测试

在部署前可以本地测试：

```bash
# 启动本地开发服务器
npx wrangler dev

# 在另一个终端测试
curl -X POST http://localhost:8787 \
  -H "Content-Type: application/json" \
  -d '{"room":"test-room","participant":"testuser"}'
```

---

## 成本说明

**Cloudflare Workers 免费版**：
- ✅ 每天 100,000 次请求
- ✅ 10ms CPU 时间/请求
- ✅ 全球 CDN 加速

**付费版**：$5/月 起（超出免费额度）

对于 MVP 和小型应用，免费版完全够用！

---

## 环境变量说明

| 变量名 | 说明 | 值 |
|--------|------|-----|
| `API_KEY` | LiveKit API Key | `APIMHobLy2Nny6k`（已在 wrangler.toml 配置） |
| `API_SECRET` | LiveKit API Secret | 从 LiveKit Cloud 获取（需手动设置） |

---

## 故障排查

### 部署失败
```bash
# 查看详细日志
npx wrangler deploy --dry-run
```

### Token 生成失败
检查 Cloudflare Dashboard：
1. Workers → cove-token-server
2. **Logs** → 查看错误信息

### CORS 错误
确保 iOS 请求添加了正确的 headers：
```swift
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
```

---

## 安全建议

1. **不要提交 API Secret 到 Git**
   - 已添加到 `.gitignore`
   - 使用 `wrangler secret` 命令设置

2. **限制 Worker 访问**
   - 可以添加域名白名单
   - 或使用 Cloudflare Access

3. **监控使用量**
   - Dashboard → Workers → Analytics
   - 设置使用量告警

---

## 下一步

1. ✅ 部署 Worker
2. ✅ 测试 API
3. ✅ 更新 iOS 代码
4. ✅ 测试语音房间功能

需要帮助？访问：
- Cloudflare Docs: https://developers.cloudflare.com/workers/
- LiveKit Docs: https://docs.livekit.io/
