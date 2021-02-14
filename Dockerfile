FROM ubuntu

# Ubuntu init
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget xz-utils -y
RUN apt-get autoremove -y

# Install node js
RUN mkdir /downloads
WORKDIR /downloads
RUN wget https://nodejs.org/dist/v14.15.5/node-v14.15.5-linux-x64.tar.xz
RUN ls -lt
RUN tar -xf 'node-v14.15.5-linux-x64.tar.xz'
ENV PATH=/downloads/node-v14.15.5-linux-x64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create the npm package.json
WORKDIR /
RUN mkdir /work
WORKDIR /work
RUN npm set init.name "styles"
RUN npm init --yes
RUN ls

# Install tailwindcss
RUN npm install tailwindcss@latest postcss@latest autoprefixer@latest clean-css-cli@latest
ENV PATH=/work/node_modules/clean-css-cli/bin:/downloads/node-v14.15.5-linux-x64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY package.json .
COPY postcss.config.js .
COPY prod.sh .

## Where the input tailwind.css file can be found
VOLUME /work/input

## Where the final css will be output
VOLUME /work/output

## Where post css will search for src to remove unused tailwind bits
## Point this to the root of your base app (it looks in source_code/src/**/*.rs and source_code/index.html
VOLUME /work/source_code
