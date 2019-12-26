package main;

//import "cocoa:objc"
//import "cocoa:appkit"
//import "cocoa:foundation"

import "core:os2"
import "core:fmt"
import "core:c"

foreign {
	@(link_name="__error") 
	darwin_error_number_pointer :: proc() -> ^c.int ---;
	
	@(link_name="strerror") 
	darwin_string_error :: proc(num : c.int) -> cstring ---;
	
	@(link_name="__proc_info")
	darwin_proc_info :: proc(num : c.int, pid : c.int, flavor : c.int, arg : u64, buffer : rawptr, buffer_size : c.int) -> c.int ---;
	
	@(link_name="proc_name")
	darwin_proc_name :: proc(pid : c.int, buffer : rawptr, buffersize : u32) -> c.int ---;
	
	@(link_name="proc_pidpath")
	darwin_proc_pid_path :: proc(pid : c.int,  buffer : rawptr, buffersize : u32) -> c.int ---;
}

darwin_error_number :: proc() -> c.int {
	return darwin_error_number_pointer()^;
}

darwin_error_string :: proc() -> cstring {
	return darwin_string_error(darwin_error_number());
}

PROC_ALL_PIDS  :: c.int(1);
PROC_PGRP_ONLY :: c.int(2);
PROC_TTY_ONLY  :: c.int(3);
PROC_UID_ONLY  :: c.int(4);
PROC_RUID_ONLY :: c.int(5);
PROC_PPID_ONLY :: c.int(6);
PROC_KDBG_ONLY :: c.int(7);

PROC_INFO_CALL_LISTPIDS          :: c.int(0x1);
PROC_INFO_CALL_PIDINFO           :: c.int(0x2);
PROC_INFO_CALL_PIDFDINFO         :: c.int(0x3);
PROC_INFO_CALL_KERNMSGBUF        :: c.int(0x4);
PROC_INFO_CALL_SETCONTROL        :: c.int(0x5);
PROC_INFO_CALL_PIDFILEPORTINFO   :: c.int(0x6);
PROC_INFO_CALL_TERMINATE         :: c.int(0x7);
PROC_INFO_CALL_DIRTYCONTROL      :: c.int(0x8);
PROC_INFO_CALL_PIDRUSAGE         :: c.int(0x9);
PROC_INFO_CALL_PIDORIGINATORINFO :: c.int(0xa);
PROC_INFO_CALL_LISTCOALITIONS    :: c.int(0xb);
PROC_INFO_CALL_CANUSEFGHW        :: c.int(0xc);
PROC_INFO_CALL_PIDDYNKQUEUEINFO  :: c.int(0xd);
PROC_INFO_CALL_UDATA_INFO        :: c.int(0xe);

PROC_PIDTBSDINFO	::	c.int(3);

struct proc_bsdinfo {
  pbi_flags u32;		/* 64bit; emulated etc */
  pbi_status u32;
  pbi_xstatus u32;
  pbi_pid u32;
  pbi_ppid u32;
	uid_t			pbi_uid;
	gid_t			pbi_gid;
	uid_t			pbi_ruid;
	gid_t			pbi_rgid;
	uid_t			pbi_svuid;
	gid_t			pbi_svgid;
  rfu_1;			/* reserved */
	u8			pbi_comm[MAXCOMLEN];
	u8			pbi_name[2*MAXCOMLEN];	/* empty if no name is registered */
  pbi_nfiles u32;
  pbi_pgid u32;
  pbi_pjobc u32;
  e_tdev u32;			/* controlling tty dev */
  e_tpgid u32;		/* tty process group id */
	int32_t			pbi_nice;
	uint64_t		pbi_start_tvsec;
	uint64_t		pbi_start_tvusec;
};

proc_name :: proc(pid : c.int, buffer : rawptr, uint32_t buffersize) -> c.int
{
	retval = 0 : c.int,
	length = 0 : c.int;
	proc_bsdinfo pbsd;
	
	if (buffersize < sizeof(pbsd.pbi_name)) {
		errno = ENOMEM;
		return(0);
	}

	retval = proc_pidinfo(pid, PROC_PIDTBSDINFO, (uint64_t)0, &pbsd, sizeof(struct proc_bsdinfo));
	if (retval != 0) {
		if (pbsd.pbi_name[0]) {
			bcopy(&pbsd.pbi_name, buffer, sizeof(pbsd.pbi_name));
		} else {
			bcopy(&pbsd.pbi_comm, buffer, sizeof(pbsd.pbi_comm));
		}
		len = strlen(buffer);
		return(len);
	}
	return(0);
}

process_pids :: proc () -> c.int {
	buffer : [4096]c.int;
	return_value := c.int(0);
	
	darwin_proc_info(PROC_INFO_CALL_LISTPIDS, PROC_ALL_PIDS, 0, u64(0), &buffer[0], 1024);
	return_value = darwin_proc_info(PROC_INFO_CALL_LISTPIDS, PROC_ALL_PIDS, 0, u64(0), &buffer[0], 1024);
	if(return_value == -1) {
		return 0;
	} 
	
	fmt.printf("buffer: %v\n", buffer);
	
	return return_value;
}

main :: proc() {
	
	fmt.printf("user: '%s'\n", os2.user_name());
	fmt.printf("home: '%s'\n", os2.user_home_directory());
	fmt.printf("uid: %d\n",    os2.user_id());
	fmt.printf("gid: %d\n",    os2.group_id());
	fmt.printf("pid: %d\n",    os2.process_id());
	fmt.printf("hostname: %s\n", os2.host_name());
	fmt.printf("program name: %s\n", os2.executable());
	fmt.printf("page size: %d byte\n", os2.page_size());
	fmt.printf("physical memory: %d gb\n", os2.physical_ram());
	fmt.printf("process count: %d\n", os2.process_count());
	fmt.printf("cpu count: %d\n", os2.cpu_count());
	
	path : [4096]u8;
	darwin_proc_pid_path(cast(i32)os2.process_id(), &path, 4096);
	fmt.printf("proc path: %.*s\n", len(path), cast(cstring)&path[0]);
		
	darwin_proc_name(cast(i32)os2.process_id(), &path, 4096);
	fmt.printf("proc name: %.*s\n", len(path), cast(cstring)&path[0]);
	
	os2.exit(1);
}