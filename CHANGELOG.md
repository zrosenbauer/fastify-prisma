# @zrosenbauer/fastify-prisma

## 7.0.2

### Patch Changes

- [#413](https://github.com/zrosenbauer/fastify-prisma/pull/413) [`3b316b6`](https://github.com/zrosenbauer/fastify-prisma/commit/3b316b60bce7c8c8ffa6f74ec7cc95ba1bb5de90) Thanks [@zrosenbauer](https://github.com/zrosenbauer)! - Bump dependencies to latest: `@prisma/client` 7.3.0 → 7.8.0 (and matching `prisma`/`@prisma/adapter-better-sqlite3` in dev), `fastify` 5.7.2 → 5.8.5, `vitest` 4.0.18 → 4.1.6, `typescript` 5.9.3 → 6.0.3, plus minor/patch bumps across `@biomejs/biome`, `better-sqlite3`, `pkgroll`, `rimraf`, `type-fest`, `vite-tsconfig-paths`.

- [#400](https://github.com/zrosenbauer/fastify-prisma/pull/400) [`bf11f98`](https://github.com/zrosenbauer/fastify-prisma/commit/bf11f98e8e3b673974b32653eadedfd5b2ba55d0) Thanks [@zrosenbauer](https://github.com/zrosenbauer)! - Renamed package from `@joggr/fastify-prisma` to `@zrosenbauer/fastify-prisma`. The repository has moved to [`zrosenbauer/fastify-prisma`](https://github.com/zrosenbauer/fastify-prisma). The `@joggr/fastify-prisma` package is deprecated at `v7.0.1`; install `@zrosenbauer/fastify-prisma` for future updates.

  Releases now go through [Changesets](https://github.com/changesets/changesets) + npm [Trusted Publishing](https://docs.npmjs.com/trusted-publishers) (no long-lived tokens, signed provenance on every publish).
