#
# OMNeT++/OMNEST Makefile for Homenet
#
# This file was generated with the command:
#  opp_makemake -f --deep -O out -I../inet/src/linklayer/ethernet -I../inet/src/networklayer/ipv4 -I../inet/src/networklayer/common -I../inet/src/networklayer/rsvp_te -I../inet/src/networklayer/icmpv6 -I../inet/src/transport/tcp -I../inet/src/networklayer/mpls -I../inet/src/base -I../inet/src/networklayer/ted -I../inet/src/util/headerserializers -I../inet/src/networklayer/contract -I../inet/obsolete/rsvp_te -I../inet/src/util -I../inet/src/transport/contract -I../inet/src/networklayer/ipv6 -I../inet/src/transport/sctp -I../inet/src/linklayer/mfcore -I../inet/src/world -I../inet/src/applications/pingapp -I../inet/src/linklayer/contract -I../inet/src/networklayer/arp -I../inet/src/networklayer/ldp -I../inet/src/transport/udp -L../inet/out/$(CONFIGNAME)/src -linet -KINET_PROJ=../inet
#

# Name of target to be created (-o option)
TARGET = Homenet$(EXE_SUFFIX)

# User interface (uncomment one) (-u option)
USERIF_LIBS = $(ALL_ENV_LIBS) # that is, $(TKENV_LIBS) $(CMDENV_LIBS)
#USERIF_LIBS = $(CMDENV_LIBS)
#USERIF_LIBS = $(TKENV_LIBS)

# C++ include paths (with -I)
INCLUDE_PATH = \
    -I../inet/src/linklayer/ethernet \
    -I../inet/src/networklayer/ipv4 \
    -I../inet/src/networklayer/common \
    -I../inet/src/networklayer/rsvp_te \
    -I../inet/src/networklayer/icmpv6 \
    -I../inet/src/transport/tcp \
    -I../inet/src/networklayer/mpls \
    -I../inet/src/base \
    -I../inet/src/networklayer/ted \
    -I../inet/src/util/headerserializers \
    -I../inet/src/networklayer/contract \
    -I../inet/obsolete/rsvp_te \
    -I../inet/src/util \
    -I../inet/src/transport/contract \
    -I../inet/src/networklayer/ipv6 \
    -I../inet/src/transport/sctp \
    -I../inet/src/linklayer/mfcore \
    -I../inet/src/world \
    -I../inet/src/applications/pingapp \
    -I../inet/src/linklayer/contract \
    -I../inet/src/networklayer/arp \
    -I../inet/src/networklayer/ldp \
    -I../inet/src/transport/udp \
    -I. \
    -Idoc \
    -Idoc/doxy \
    -Idoc/doxy/search \
    -Idoc/neddoc \
    -Isimulations \
    -Isimulations/inis \
    -Isimulations/results \
    -Isimulations/results/S1_Ping \
    -Isimulations/results/S1_TCP \
    -Isimulations/results/S1_UDP \
    -Isimulations/results/S2_Ping \
    -Isimulations/results/S2_TCP \
    -Isimulations/results/S2_UDP \
    -Isimulations/results/S3_Ping \
    -Isimulations/results/S3_Ping_Drop \
    -Isimulations/results/S3_TCP \
    -Isimulations/results/S3_TCP_DROP \
    -Isimulations/results/S3_UDP \
    -Isimulations/results/S3_UDP_DROP \
    -Isrc

# Additional object and library files to link with
EXTRA_OBJS =

# Additional libraries (-L, -l options)
LIBS = -L../inet/out/$(CONFIGNAME)/src  -linet
LIBS += -Wl,-rpath,`abspath ../inet/out/$(CONFIGNAME)/src`

# Output directory
PROJECT_OUTPUT_DIR = out
PROJECTRELATIVE_PATH =
O = $(PROJECT_OUTPUT_DIR)/$(CONFIGNAME)/$(PROJECTRELATIVE_PATH)

# Object files for local .cc and .msg files
OBJS = $O/src/Values.o $O/src/ThM.o $O/src/HomenetDropQueue.o $O/src/Decider.o $O/src/Copy.o

# Message files
MSGFILES =

# Other makefile variables (-K)
INET_PROJ=../inet

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
	-rm -f doc/*_m.cc doc/*_m.h
	-rm -f doc/doxy/*_m.cc doc/doxy/*_m.h
	-rm -f doc/doxy/search/*_m.cc doc/doxy/search/*_m.h
	-rm -f doc/neddoc/*_m.cc doc/neddoc/*_m.h
	-rm -f simulations/*_m.cc simulations/*_m.h
	-rm -f simulations/inis/*_m.cc simulations/inis/*_m.h
	-rm -f simulations/results/*_m.cc simulations/results/*_m.h
	-rm -f simulations/results/S1_Ping/*_m.cc simulations/results/S1_Ping/*_m.h
	-rm -f simulations/results/S1_TCP/*_m.cc simulations/results/S1_TCP/*_m.h
	-rm -f simulations/results/S1_UDP/*_m.cc simulations/results/S1_UDP/*_m.h
	-rm -f simulations/results/S2_Ping/*_m.cc simulations/results/S2_Ping/*_m.h
	-rm -f simulations/results/S2_TCP/*_m.cc simulations/results/S2_TCP/*_m.h
	-rm -f simulations/results/S2_UDP/*_m.cc simulations/results/S2_UDP/*_m.h
	-rm -f simulations/results/S3_Ping/*_m.cc simulations/results/S3_Ping/*_m.h
	-rm -f simulations/results/S3_Ping_Drop/*_m.cc simulations/results/S3_Ping_Drop/*_m.h
	-rm -f simulations/results/S3_TCP/*_m.cc simulations/results/S3_TCP/*_m.h
	-rm -f simulations/results/S3_TCP_DROP/*_m.cc simulations/results/S3_TCP_DROP/*_m.h
	-rm -f simulations/results/S3_UDP/*_m.cc simulations/results/S3_UDP/*_m.h
	-rm -f simulations/results/S3_UDP_DROP/*_m.cc simulations/results/S3_UDP_DROP/*_m.h
	-rm -f src/*_m.cc src/*_m.h

cleanall: clean
	-rm -rf $(PROJECT_OUTPUT_DIR)

depend:
	$(MAKEDEPEND) $(INCLUDE_PATH) -f Makefile -P\$$O/ -- $(MSG_CC_FILES)  ./*.cc doc/*.cc doc/doxy/*.cc doc/doxy/search/*.cc doc/neddoc/*.cc simulations/*.cc simulations/inis/*.cc simulations/results/*.cc simulations/results/S1_Ping/*.cc simulations/results/S1_TCP/*.cc simulations/results/S1_UDP/*.cc simulations/results/S2_Ping/*.cc simulations/results/S2_TCP/*.cc simulations/results/S2_UDP/*.cc simulations/results/S3_Ping/*.cc simulations/results/S3_Ping_Drop/*.cc simulations/results/S3_TCP/*.cc simulations/results/S3_TCP_DROP/*.cc simulations/results/S3_UDP/*.cc simulations/results/S3_UDP_DROP/*.cc src/*.cc

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
$O/src/Decider.o: src/Decider.cc \
	src/Decider.h
$O/src/HomenetDropQueue.o: src/HomenetDropQueue.cc \
	src/HomenetDropQueue.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/base/IPassiveQueue.h \
	$(INET_PROJ)/src/base/PassiveQueueBase.h
$O/src/ThM.o: src/ThM.cc \
	src/ThM.h \
	src/Values.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/networklayer/contract/IPAddress.h \
	$(INET_PROJ)/src/networklayer/contract/IPv6Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddress.h \
	$(INET_PROJ)/src/transport/contract/TCPCommand_m.h
$O/src/Values.o: src/Values.cc \
	src/Values.h

