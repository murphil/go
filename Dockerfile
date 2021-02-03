FROM nnurphy/ub

ENV GOROOT=/opt/go GOPATH=${HOME:-/root}/go
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:$PATH
ENV GO111MODULE=on
RUN set -ex \
  ; cd /opt \
  ; GO_VERSION=$(curl https://golang.org/VERSION?m=text) \
  ; wget -q -O- https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz \
      | tar xzf - \
  ; go get -u -v \
      github.com/juju/errors \
      github.com/spf13/viper \
      github.com/sirupsen/logrus \
      github.com/gin-gonic/gin \
      github.com/jinzhu/gorm \
      honnef.co/go/tools/... \
      github.com/mgechev/revive \
      github.com/go-delve/delve/cmd/dlv \
      2>&1 \
  ; go get golang.org/x/tools/gopls@latest \
  ; rm -rf $(go env GOCACHE)/* \
  ; go env -w GOPROXY=https://goproxy.cn,direct

RUN set -eux \
  ; nvim_home=/etc/skel/.config/nvim \
  ; $nvim_home/plugged/vimspector/install_gadget.py --enable-go \
  ; rm -f $nvim_home/plugged/vimspector/gadgets/linux/download/*/*/*.vsix
