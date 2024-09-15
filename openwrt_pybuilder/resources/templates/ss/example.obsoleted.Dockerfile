FROM xxy1991/openwrt:imagebuilder-19.07.8

ENV REPO_BASE=http://openwrt-dist.sourceforge.net/packages
RUN echo "" >> repositories.conf && \
    echo "src/gz openwrt_dist ${REPO_BASE}/base/x86_64" \
        >> repositories.conf && \
    echo "src/gz openwrt_dist_luci ${REPO_BASE}/luci" \
        >> repositories.conf
