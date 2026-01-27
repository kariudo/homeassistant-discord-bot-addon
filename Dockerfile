# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1 AS base
WORKDIR /usr/src/app

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json bun.lockb /temp/dev/
RUN cd /temp/dev && bun install --frozen-lockfile

# install with --production (exclude devDependencies)
RUN mkdir -p /temp/prod
COPY package.json bun.lockb /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules node_modules
COPY . .

# build
ENV NODE_ENV=production
RUN bun run build

# copy production dependencies and source code into final image
FROM base AS release
COPY --from=install /temp/prod/node_modules node_modules
COPY --from=prerelease /usr/src/app/dist/index.js .
COPY --from=prerelease /usr/src/app/package.json .


# Install jq for JSON parsing in run script
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

# Copy addon run script
COPY addon/run.sh /
RUN chmod +x /run.sh

# Create app directory for the application files
WORKDIR /app
RUN mkdir -p /app/dist
COPY --from=prerelease /usr/src/app/dist/index.js /app/dist/
COPY --from=prerelease /usr/src/app/package.json /app/

# Copy both start scripts - universal entry point will choose which to use
COPY addon/run.sh /start-addon.sh
COPY start.sh /start.sh
RUN chmod +x /start.sh /start-addon.sh

# Universal entrypoint that detects deployment mode
ENTRYPOINT [ "/start.sh" ]
