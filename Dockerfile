FROM mcr.microsoft.com/dotnet/runtime:5.0

ARG CHROME_VERSION="84.0.4147.89-1"
RUN apt-get update
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb --no-install-recommends --allow-downgrades fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
    && rm /tmp/chrome.deb

#Add user, so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

WORKDIR /app
RUN usermod -G root pptruser

#Run everything after as non-privileged user.
RUN chown -R pptruser:pptruser /app
USER pptruser

ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome"