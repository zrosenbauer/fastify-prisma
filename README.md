# fastify-prisma

[![npm version](https://img.shields.io/npm/v/%40joggr/fastify-prisma)](https://www.npmjs.com/package/@joggr/fastify-prisma)
[![ci: Code Standards & Testing](https://github.com/joggrdocs/fastify-prisma/actions/workflows/ci.yaml/badge.svg)](https://github.com/joggrdocs/fastify-prisma/actions/workflows/ci.yaml)
[![Formatted with Biome](https://img.shields.io/badge/Formatted_with-Biome-60a5fa?style=flat&logo=biome)](https://biomejs.dev/)

> [!WARNING]
> **This package has been renamed.** `@joggr/fastify-prisma` is deprecated and will no longer receive updates after `v7.0.1`. Future releases are published as [`@zrosenbauer/fastify-prisma`](https://www.npmjs.com/package/@zrosenbauer/fastify-prisma). The canonical repository is now [`zrosenbauer/fastify-prisma`](https://github.com/zrosenbauer/fastify-prisma).
>
> To migrate:
> ```diff
> - npm i @joggr/fastify-prisma
> + npm i @zrosenbauer/fastify-prisma
> ```

Fastify Prisma plugin to share the same `PrismaClient` across your entire server.

```typescript
const allTheDucks = await server.prisma.rubberDucky.findMany();
```

## Requirements

- `fastify` >= 5.x
- `@prisma/client` >= 6.x
- `prisma` set up using the `output` config [👉 see docs](https://www.prisma.io/docs/orm/prisma-client/setup-and-configuration/generating-prisma-client)

## Getting Started

Before using this plugin you will need to have [`prisma`](https://www.prisma.io/docs/getting-started) set up. Once you are all set with `prisma` install the package and register the plugin on your server.

### Install the package

**npm**

```shell
npm i @joggr/fastify-prisma
```

**yarn**

```shell
yarn add @joggr/fastify-prisma
```

**pnpm**

```shell
pnpm add @joggr/fastify-prisma
```

### Register the plugin

#### `javascript`

```javascript
const fastifyPrisma = require('@joggr/fastify-prisma');
const { PrismaClient } = require('../my-prisma-client');

await fastify.register(fastifyPrisma, {
  client: new PrismaClient(),
});
```

#### `typescript`

```typescript
import fastifyPrisma from '@joggr/fastify-prisma';
import { PrismaClient } from '../my-prisma-client';

// Add this so you get types across the board
declare module 'fastify' {
  interface FastifyInstance {
    prisma: PrismaClient;
  }
}

await fastify.register(fastifyPrisma, {
  client: new PrismaClient(),
});
```

>[!WARN]
> Make sure you add in the module declaration or you won't have types!

### Accessing the `prisma` client

```typescript
async function somePlugin (server, opts) {
  const ducks = await server.prisma.rubberDucky.findMany();

  // do something with the ducks, log for now
  server.log.warn({ ducks }, "🐥🐥 There are lots of ducks! 🐥🐥");
}
```

> [!TIP]
> You can see a working example of this in the [examples](./examples) directory.

## Version Compatibility

Different versions of this library support different versions of `fastify` and `@prisma/client`. Please use the version you need based on your project's dependencies.

The table below shows the compatibility matrix.

| `@joggrdocs/fastify-prisma` | `fastify` | `@prisma/client`  | status       |
| ---------------------------- | --------- | ---------------- | ------------ |
| `7.x`                        | `5.x`     | `7.x`            | `active`     |
| `6.x`                        | `5.x`     | `6.x`            | `active`     |
| `5.x`                        | `5.x`     | `6.x`            | `deprecated` |
| `4.x`                        | `5.x`     | `5.x`            | `deprecated` |
| `1.x` - `3.x`                | `4.x`     | `4.x \|\| 5.x`   | `deprecated` |

## License

Licensed under MIT.
