# only for 18.06.2
FROM xxy1991/openwrt:imagebuilder

ENV BASE_URL="http://downloads.openwrt.org/releases"
ENV PAK_NAME="softethervpn_4.22-9634-1_x86_64.ipk"
ENV PAK_URL=${BASE_URL}"/packages-17.01/x86_64/packages/"${PAK_NAME}

RUN wget -P packages -q ${PAK_URL}
