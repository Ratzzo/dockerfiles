FROM archlinux

RUN	pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm nodejs yarn
RUN pacman -Sy --noconfirm chromium && yarn global add puppeteer && puppeteer browsers install chrome
RUN pacman -Scc --noconfirm
