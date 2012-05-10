#
# OMNeT++/OMNEST Makefile for Homenet
#
# This file was generated with the command:
#  opp_makemake -f --deep -O out -I../Inet/src/linklayer/ethernet -I../Inet/src/networklayer/ipv4 -I../Inet/src/networklayer/common -I../Inet/src/networklayer/rsvp_te -I../Inet/src/networklayer/icmpv6 -I../Inet/src/transport/tcp -I../Inet/src/networklayer/mpls -I../Inet/src/base -I../Inet/src/networklayer/ted -I../Inet/src/util/headerserializers -I../Inet/src/networklayer/contract -I../Inet/obsolete/rsvp_te -I../Inet/src/util -I../Inet/src/transport/contract -I../Inet/src/networklayer/ipv6 -I../Inet/src/transport/sctp -I../Inet/src/linklayer/mfcore -I../Inet/src/world -I../Inet/src/applications/pingapp -I../Inet/src/linklayer/contract -I../Inet/src/networklayer/arp -I../Inet/src/networklayer/ldp -I../Inet/src/transport/udp -L../Inet/out/$(CONFIGNAME)/src -linet -KINET_PROJ=../Inet
#

# Name of target to be created (-o option)
TARGET = Homenet$(EXE_SUFFIX)

# User interface (uncomment one) (-u option)
USERIF_LIBS = $(ALL_ENV_LIBS) # that is, $(TKENV_LIBS) $(CMDENV_LIBS)
#USERIF_LIBS = $(CMDENV_LIBS)
#USERIF_LIBS = $(TKENV_LIBS)

# C++ include paths (with -I)
INCLUDE_PATH = \
    -I../Inet/src/linklayer/ethernet \
    -I../Inet/src/networklayer/ipv4 \
    -I../Inet/src/networklayer/common \
    -I../Inet/src/networklayer/rsvp_te \
    -I../Inet/src/networklayer/icmpv6 \
    -I../Inet/src/transport/tcp \
    -I../Inet/src/networklayer/mpls \
    -I../Inet/src/base \
    -I../Inet/src/networklayer/ted \
    -I../Inet/src/util/headerserializers \
    -I../Inet/src/networklayer/contract \
    -I../Inet/obsolete/rsvp_te \
    -I../Inet/src/util \
    -I../Inet/src/transport/contract \
    -I../Inet/src/networklayer/ipv6 \
    -I../Inet/src/transport/sctp \
    -I../Inet/src/linklayer/mfcore \
    -I../Inet/src/world \
    -I../Inet/src/applications/pingapp \
    -I../Inet/src/linklayer/contract \
    -I../Inet/src/networklayer/arp \
    -I../Inet/src/networklayer/ldp \
    -I../Inet/src/transport/udp \
    -I. \
    -Isimulations \
    -Isimulations/results \
    -Isrc

# Additional object and library files to link with
EXTRA_OBJS =

# Additional libraries (-L, -l options)
LIBS = -L../Inet/out/$(CONFIGNAME)/src  -linet
LIBS += -Wl,-rpath,`abspath ../Inet/out/$(CONFIGNAME)/src`

# Output directory
PROJECT_OUTPUT_DIR = out
PROJECTRELATIVE_PATH =
O = $(PROJECT_OUTPUT_DIR)/$(CONFIGNAME)/$(PROJECTRELATIVE_PATH)

# Object files for local .cc and .msg files
OBJS = $O/src/HomenetDecider.o $O/src/Values.o $O/src/HomenetThM.o $O/src/Copy.o

# Message files
MSGFILES =

# Other makefile variables (-K)
INET_PROJ=../Inet

#------------------------------------------------------------------------------

# Pull in OMNeT++ configuration (Makefile.inc or configuser.vc)

ifneq ("$(OMNETPP_CONFIGFILE)","")
CONFIGFILE = $(OMNETPP_CONFIGFILE)
else
ifneq ("$(OMNETPP_ROOT)","")
CONFIGFILE = $(OMNETPP_ROOT)/Makefile.inc
else
CONFIGFILE = $(shell opp_configfilepath)
endif
endif

ifeq ("$(wildcard $(CONFIGFILE))","")
$(error Config file '$(CONFIGFILE)' does not exist -- add the OMNeT++ bin directory to the path so that opp_configfilepath can be found, or set the OMNETPP_CONFIGFILE variable to point to Makefile.inc)
endif

include $(CONFIGFILE)

# Simulation kernel and user interface libraries
OMNETPP_LIB_SUBDIR = $(OMNETPP_LIB_DIR)/$(TOOLCHAIN_NAME)
OMNETPP_LIBS = -L"$(OMNETPP_LIB_SUBDIR)" -L"$(OMNETPP_LIB_DIR)" -loppmain$D $(USERIF_LIBS) $(KERNEL_LIBS) $(SYS_LIBS)

COPTS = $(CFLAGS)  $(INCLUDE_PATH) -I$(OMNETPP_INCL_DIR)
MSGCOPTS = $(INCLUDE_PATH)

# we want to recompile everything if COPTS changes,
# so we store COPTS into $COPTS_FILE and have object
# files depend on it (except when "make depend" was called)
COPTS_FILE = $O/.last-copts
ifneq ($(MAKECMDGOALS),depend)
ifneq ("$(COPTS)","$(shell cat $(COPTS_FILE) 2>/dev/null || echo '')")
$(shell $(MKPATH) "$O" && echo "$(COPTS)" >$(COPTS_FILE))
endif
endif

#------------------------------------------------------------------------------
# User-supplied makefile fragment(s)
# >>>
# <<<
#------------------------------------------------------------------------------

# Main target
all: $(TARGET)

$(TARGET) : $O/$(TARGET)
	$(LN) $O/$(TARGET) .

$O/$(TARGET): $(OBJS)  $(wildcard $(EXTRA_OBJS)) Makefile
	@$(MKPATH) $O
	$(CXX) $(LDFLAGS) -o $O/$(TARGET)  $(OBJS) $(EXTRA_OBJS) $(WHOLE_ARCHIVE_ON) $(LIBS) $(WHOLE_ARCHIVE_OFF) $(OMNETPP_LIBS)

.PHONY:

.SUFFIXES: .cc

$O/%.o: %.cc $(COPTS_FILE)
	@$(MKPATH) $(dir $@)
	$(CXX) -c $(COPTS) -o $@ $<

%_m.cc %_m.h: %.msg
	$(MSGC) -s _m.cc $(MSGCOPTS) $?

msgheaders: $(MSGFILES:.msg=_m.h)

clean:
	-rm -rf $O
	-rm -f Homenet Homenet.exe libHomenet.so libHomenet.a libHomenet.dll libHomenet.dylib
	-rm -f ./*_m.cc ./*_m.h
	-rm -f simulations/*_m.cc simulations/*_m.h
	-rm -f simulations/results/*_m.cc simulations/results/*_m.h
	-rm -f src/*_m.cc src/*_m.h

cleanall: clean
	-rm -rf $(PROJECT_OUTPUT_DIR)

depend:
	$(MAKEDEPEND) $(INCLUDE_PATH) -f Makefile -P\$$O/ -- $(MSG_CC_FILES)  ./*.cc simulations/*.cc simulations/results/*.cc src/*.cc

# DO NOT DELETE THIS LINE -- make depend depends on it.
$O/src/Copy.o: src/Copy.cc \
	src/Copy.h \
	src/Values.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/base/INotifiable.h \
	$(INET_PROJ)/src/base/ModuleAccess.h \
	$(INET_PROJ)/src/base/NotificationBoard.h \
	$(INET_PROJ)/src/base/NotifierConsts.h \
	$(INET_PROJ)/src/linklayer/contract/Ieee802Ctrl_m.h \
	$(INET_PROJ)/src/linklayer/contract/MACAddress.h \
	$(INET_PROJ)/src/linklayer/contract/TxNotifDetails.h \
	$(INET_PROJ)/src/linklayer/ethernet/EtherFrame_m.h \
	$(INET_PROJ)/src/linklayer/ethernet/EtherMAC.h \
	$(INET_PROJ)/src/linklayer/ethernet/EtherMACBase.h \
	$(INET_PROJ)/src/linklayer/ethernet/Ethernet.h \
	$(INET_PROJ)/src/networklayer/arp/ARPPacket_m.h \
	$(INET_PROJ)/src/networklayer/common/IInterfaceTable.h \
	$(INET_PROJ)/src/networklayer/common/InterfaceEntry.h \
	$(INET_PROJ)/src/networklayer/common/InterfaceTableAccess.h \
	$(INET_PROJ)/src/networklayer/common/InterfaceToken.h \
	$(INET_PROJ)/src/networklayer/contract/IPAddress.h
$O/src/HomenetDecider.o: src/HomenetDecider.cc \
	src/HomenetDecider.h
$O/src/HomenetThM.o: src/HomenetThM.cc \
	src/HomenetThM.h \
	src/Values.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/networklayer/contract/IPAddress.h \
	$(INET_PROJ)/src/networklayer/contract/IPv6Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddress.h \
	$(INET_PROJ)/src/transport/contract/TCPCommand_m.h
$O/src/Values.o: src/Values.cc \
	src/Values.h

