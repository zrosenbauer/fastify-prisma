import fastifyPrisma from '@zrosenbauer/fastify-prisma';
import Fastify from 'fastify';
import rubberDuckies from '#/routes/rubber-duckies.js';
import { PrismaClient } from '#prisma/client';

declare module 'fastify' {
  interface FastifyInstance {
    prisma: PrismaClient;
  }
}

const fastify = Fastify({
  logger: true,
});

const start = async () => {
  try {
    // Register the Prisma plugin using a custom Prisma client instance
    // that's output is not the legacy node_modules output
    await fastify.register(fastifyPrisma, {
      client: new PrismaClient(),
    });

    fastify.register(rubberDuckies);

    await fastify.listen({ port: 3000 });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
