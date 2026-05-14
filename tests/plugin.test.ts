import { PrismaBetterSqlite3 } from "@prisma/adapter-better-sqlite3";
import Fastify from "fastify";
import { afterEach, beforeEach, describe, expect, it } from "vitest";
import prismaPlugin from "../src/index";
import { PrismaClient } from "./prisma/client/client";

describe("plugin", () => {
  // oxlint-disable-next-line no-explicit-any -- test fixture only
  let fastify: any;
  let client: PrismaClient;
  beforeEach(() => {
    const adapter = new PrismaBetterSqlite3({
      url: "file:./tests/prisma/faux.db",
    });
    client = new PrismaClient({ adapter });
    fastify = Fastify();
    fastify.register(prismaPlugin, { client });
    return fastify.ready();
  });

  afterEach(() => fastify.close());

  it("should register `fastify.prisma`", async () => {
    expect(fastify.prisma).toBeDefined();
  });

  it("should decorate `fastify.prisma` with valid prisma object", async () => {
    expect(await fastify.prisma.rubberDucky.count()).toBe(2);
  });

  it("should fail if registering plugin more than once", async () => {
    const fastifyWithErrors = Fastify();
    await fastifyWithErrors.register(prismaPlugin, { client });
    await expect(fastifyWithErrors.register(prismaPlugin, { client })).rejects.toThrow(
      "A `prisma` decorator has already been registered, please ensure you are not registering multiple instances of this plugin",
    );
  });
});
