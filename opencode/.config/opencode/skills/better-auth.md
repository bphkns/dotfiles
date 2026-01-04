# better-auth - D1 Adapter & Error Prevention Guide

**Package**: better-auth@1.4.0 (Nov 22, 2025)
**Breaking Changes**: ESM-only (v1.4.0), Multi-team table changes (v1.3), D1 requires Drizzle/Kysely (no direct adapter)

---

## CRITICAL: D1 Adapter Requirement

better-auth **DOES NOT** have `d1Adapter()`. You **MUST** use:
- **Drizzle ORM** (recommended): `drizzleAdapter(db, { provider: "sqlite" })`
- **Kysely**: `new Kysely({ dialect: new D1Dialect({ database: env.DB }) })`

---

## What's New in v1.4.0 (Nov 22, 2025)

**Major Features:**
- **Stateless session management** - Sessions without database storage
- **ESM-only package** ⚠️ Breaking: CommonJS no longer supported
- **JWT key rotation** - Automatic key rotation for enhanced security
- **SCIM provisioning** - Enterprise user provisioning protocol
- **@standard-schema/spec** - Replaces ZodType for validation
- **CaptchaFox integration** - Built-in CAPTCHA support
- Automatic server-side IP detection
- Cookie-based account data storage
- Multiple passkey origins support
- RP-Initiated Logout endpoint (OIDC)

📚 **Docs**: https://www.better-auth.com/changelogs

---

## What's New in v1.3 (July 2025)

**Major Features:**
- **SSO with SAML 2.0** - Enterprise single sign-on (moved to separate `@better-auth/sso` package)
- **Multi-team support** ⚠️ Breaking: `teamId` removed from member table, new `teamMembers` table required
- **Additional fields** - Custom fields for organization/member/invitation models
- Performance improvements and bug fixes

📚 **Docs**: https://www.better-auth.com/blog/1-3

---

## Alternative: Kysely Adapter Pattern

If you prefer Kysely over Drizzle:

**File**: `src/auth.ts`

```typescript
import { betterAuth } from "better-auth";
import { Kysely, CamelCasePlugin } from "kysely";
import { D1Dialect } from "kysely-d1";

type Env = {
  DB: D1Database;
  BETTER_AUTH_SECRET: string;
};

export function createAuth(env: Env) {
  return betterAuth({
    secret: env.BETTER_AUTH_SECRET,
    database: {
      db: new Kysely({
        dialect: new D1Dialect({ database: env.DB }),
        plugins: [new CamelCasePlugin()],
      }),
      type: "sqlite",
    },
    emailAndPassword: { enabled: true },
  });
}
```

**Why CamelCasePlugin?** If your Drizzle schema uses `snake_case` column names (e.g., `email_verified`), but better-auth expects `camelCase` (e.g., `emailVerified`), the `CamelCasePlugin` automatically converts between the two.

---

## Framework Integrations

### TanStack Start

**⚠️ CRITICAL**: TanStack Start requires the `reactStartCookies` plugin to handle cookie setting properly.

```typescript
import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { reactStartCookies } from "better-auth/react-start";

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: "sqlite" }),
  plugins: [
    twoFactor(),
    organization(),
    reactStartCookies(), // ⚠️ MUST be LAST plugin
  ],
});
```

**Why it's needed**: TanStack Start uses a special cookie handling system. Without this plugin, auth functions like `signInEmail()` and `signUpEmail()` won't set cookies properly, causing authentication to fail.

**API Route Setup** (`/src/routes/api/auth/$.ts`):

```typescript
import { auth } from '@/lib/auth'
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/api/auth/$')({
  server: {
    handlers: {
      GET: ({ request }) => auth.handler(request),
      POST: ({ request }) => auth.handler(request),
    },
  },
})
```

📚 **Official Docs**: https://www.better-auth.com/docs/integrations/tanstack

---

## Available Plugins (v1.3+)

| Plugin | Import | Description |
|--------|--------|-------------|
| **OIDC Provider** | `better-auth/plugins` | Build your own OpenID Connect provider |
| **SSO** | `better-auth/plugins` | Enterprise SSO with OIDC, OAuth2, SAML 2.0 |
| **Stripe** | `better-auth/plugins` | Payment and subscription management |
| **MCP** | `better-auth/plugins` | OAuth provider for Model Context Protocol |
| **Expo** | `better-auth/expo` | React Native/Expo integration |

---

## API Reference

### Auto-Generated HTTP Endpoints

All endpoints are automatically exposed at `/api/auth/*` when using `auth.handler()`.

#### Core Authentication Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/sign-up/email` | POST | Register with email/password |
| `/sign-in/email` | POST | Authenticate with email/password |
| `/sign-out` | POST | Logout user |
| `/change-password` | POST | Update password |
| `/forget-password` | POST | Initiate password reset |
| `/reset-password` | POST | Complete password reset |
| `/send-verification-email` | POST | Send email verification link |
| `/verify-email` | GET | Verify email with token |
| `/get-session` | GET | Retrieve current session |
| `/list-sessions` | GET | Get all active user sessions |
| `/revoke-session` | POST | End specific session |
| `/update-user` | POST | Modify user profile |
| `/delete-user` | POST | Remove user account |

#### Social OAuth Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/sign-in/social` | POST | Initiate OAuth flow |
| `/callback/:provider` | GET | OAuth callback handler |
| `/get-access-token` | GET | Retrieve provider access token |

---

## Known Issues & Solutions

### Issue 1: "d1Adapter is not exported" Error

```typescript
// ❌ WRONG - This doesn't exist
import { d1Adapter } from 'better-auth/adapters/d1'
database: d1Adapter(env.DB)

// ✅ CORRECT - Use Drizzle
import { drizzleAdapter } from 'better-auth/adapters/drizzle'
import { drizzle } from 'drizzle-orm/d1'
const db = drizzle(env.DB, { schema })
database: drizzleAdapter(db, { provider: "sqlite" })

// ✅ CORRECT - Use Kysely
import { Kysely } from 'kysely'
import { D1Dialect } from 'kysely-d1'
database: {
  db: new Kysely({ dialect: new D1Dialect({ database: env.DB }) }),
  type: "sqlite"
}
```

### Issue 2: Schema Generation Fails

Use Drizzle Kit to generate migrations:

```bash
npx drizzle-kit generate
wrangler d1 migrations apply my-app-db --remote
```

### Issue 3: "CamelCase" vs "snake_case" Column Mismatch

**With Kysely**:
```typescript
import { CamelCasePlugin } from "kysely";
new Kysely({
  dialect: new D1Dialect({ database: env.DB }),
  plugins: [new CamelCasePlugin()],
})
```

### Issue 4: D1 Eventual Consistency

Use Cloudflare KV for session storage:

```typescript
session: {
  storage: {
    get: async (sessionId) => {
      const session = await env.SESSIONS_KV.get(sessionId);
      return session ? JSON.parse(session) : null;
    },
    set: async (sessionId, session, ttl) => {
      await env.SESSIONS_KV.put(sessionId, JSON.stringify(session), {
        expirationTtl: ttl,
      });
    },
    delete: async (sessionId) => {
      await env.SESSIONS_KV.delete(sessionId);
    },
  },
},
```

### Issue 5: CORS Errors for SPA Applications

```typescript
import { cors } from "hono/cors";

app.use("/api/auth/*", cors({
  origin: ["https://yourdomain.com", "http://localhost:3000"],
  credentials: true,
  allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
}));
```

### Issue 6: OAuth Redirect URI Mismatch

Ensure exact match in OAuth provider settings:
```
Provider setting: https://yourdomain.com/api/auth/callback/google
better-auth URL:  https://yourdomain.com/api/auth/callback/google
```

### Issue 7: Missing Dependencies

**For Drizzle approach**:
```bash
npm install better-auth drizzle-orm drizzle-kit @cloudflare/workers-types
```

**For Kysely approach**:
```bash
npm install better-auth kysely kysely-d1 @cloudflare/workers-types
```

### Issue 8: Email Verification Not Sending

Implement `sendVerificationEmail` handler:

```typescript
emailVerification: {
  sendVerificationEmail: async ({ user, url }) => {
    await sendEmail({
      to: user.email,
      subject: "Verify your email",
      html: `<a href="${url}">Verify Email</a>`,
    });
  },
  sendOnSignUp: true,
  autoSignInAfterVerification: true,
  expiresIn: 3600,
},
```

### Issue 9: Session Expires Too Quickly

```typescript
session: {
  expiresIn: 60 * 60 * 24 * 7, // 7 days
  updateAge: 60 * 60 * 24, // Update every 24 hours
},
```

### Issue 10: Social Provider Missing User Data

```typescript
socialProviders: {
  google: {
    clientId: env.GOOGLE_CLIENT_ID,
    clientSecret: env.GOOGLE_CLIENT_SECRET,
    scope: ["openid", "email", "profile"],
  },
  github: {
    clientId: env.GITHUB_CLIENT_ID,
    clientSecret: env.GITHUB_CLIENT_SECRET,
    scope: ["user:email", "read:user"],
  },
}
```

### Issue 13: User Data Updates Not Reflecting in UI (TanStack Query)

**Root Cause**: better-auth uses **nanostores** for session state, not TanStack Query.

**Solution**: Manually notify the nanostore after updating user data:

```typescript
const { data, error } = await authClient.updateUser({
  image: newAvatarUrl,
  name: newName
})

if (!error) {
  authClient.$store.notify('$sessionSignal')
  queryClient.invalidateQueries({ queryKey: ['user-profile'] })
}
```

---

## Additional Resources

- **Homepage**: https://better-auth.com
- **GitHub**: https://github.com/better-auth/better-auth (22.4k ⭐)
- **2FA Plugin**: https://www.better-auth.com/docs/plugins/2fa
- **Organization Plugin**: https://www.better-auth.com/docs/plugins/organization
- **Admin Plugin**: https://www.better-auth.com/docs/plugins/admin
- **TanStack Start**: https://www.better-auth.com/docs/integrations/tanstack

---

## Version Compatibility

**Tested with**:
- `better-auth@1.3.34`
- `drizzle-orm@0.44.7`
- `drizzle-kit@0.31.6`
- `kysely@0.28.8`
- `kysely-d1@0.4.0`
- `hono@4.0.0`
- Node.js 18+, Bun 1.0+

---

**Last verified**: 2025-11-22 | **Skill version**: 3.0.0
