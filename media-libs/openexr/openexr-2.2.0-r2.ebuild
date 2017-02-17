# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
# changing sources. Using a revision on the binary in order
# to keep the old one for previous ebuilds.
SRC_URI="https://github.com/openexr/openexr/archive/v${PV}.tar.gz -> openexr-${PV}-r1.tar.gz"

LICENSE="BSD"
SLOT="0/22" # based on SONAME
KEYWORDS="~amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples namespace-versioning static-libs"

# Only need hard blocker for 2.2.0 series. Can remove on version bump.
RDEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]
	 ~media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP},namespace-versioning=]
	 !!=media-libs/ilmase-2.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/autoconf-archive-2016.09.16"

PATCHES=(
	"${FILESDIR}/${P}-fix-cpuid-on-abi_x86_32.patch"
	"${FILESDIR}/${P}-use-ull-for-64-bit-literals.patch"
	"${FILESDIR}/${P}-fix-build-system.patch"
	"${FILESDIR}/${P}-fix-config.h-collision.patch"
	"${FILESDIR}/${P}-fix-linker-error.patch"
	"${FILESDIR}/${P}-add-pkgconfig-file.patch"
)

S="${WORKDIR}/openexr-${PV}/OpenEXR"

src_prepare() {
	default
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die

	sed -e 's|doc/OpenEXR-${OPENEXR_VERSION}|doc/'${PF}'|' \
	    -i CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DNAMESPACE_VERSIONING=$(usex namespace-versioning)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DILMBASE_PACKAGE_PREFIX="/usr"
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs

	docompress -x /usr/share/doc/${PF}/examples
	if ! use examples; then
		rm -rf "${ED%/}"/usr/share/doc/${PF}/examples || die
	fi

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}