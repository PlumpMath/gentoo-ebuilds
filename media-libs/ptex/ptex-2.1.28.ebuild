# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Per-Face Texture Mapping for Production Rendering"
HOMEPAGE="http://ptex.us/"
SRC_URI="https://github.com/wdas/ptex/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-doc/doxygen"

KEYWORDS="~amd64 ~x86"

mycmakeargs=( -DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html )
