#include <sys/types.h>
#include <sys/event.h>
#include <sys/time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <err.h>
#include <string.h>

int
main(int argc, char *argv[])
{
        int fd, kq, nev;
        struct kevent ev;
        static const struct timespec tout = { 1, 0 };

        if ((fd = open(argv[1], O_RDONLY)) == -1)
                err(1, "Cannot open `%s'", argv[1]);

        if ((kq = kqueue()) == -1)
                err(1, "Cannot create kqueue");

        EV_SET(&ev, fd, EVFILT_VNODE, EV_ADD | EV_ENABLE | EV_CLEAR,
            NOTE_DELETE|NOTE_WRITE|NOTE_EXTEND|NOTE_ATTRIB|NOTE_LINK|
            NOTE_RENAME|NOTE_REVOKE, 0, 0);
        if (kevent(kq, &ev, 1, NULL, 0, &tout) == -1)
                err(1, "kevent");
        for (;;) {
                nev = kevent(kq, NULL, 0, &ev, 1, &tout);
                if (nev == -1)
               		err(1, "kevent");
								
                if (nev == 0)
                        continue;
								
                if (ev.fflags & NOTE_DELETE) {
                       
                        ev.fflags &= ~NOTE_DELETE;
												
												sleep(1);
												if(access(argv[1], F_OK) == 0) {
													
													close(fd);
													fd = open(argv[1], O_RDONLY);
													
													nev = kevent(kq, NULL, 0, &ev, 1, &tout);
													
													printf("atomic safe ");
												} else {
													 printf("deleted ");
												}
												
                }
                if (ev.fflags & NOTE_WRITE) {
                        printf("written ");
                        ev.fflags &= ~NOTE_WRITE;
                }
                if (ev.fflags & NOTE_EXTEND) {
                        printf("extended ");
                        ev.fflags &= ~NOTE_EXTEND;
                }
                if (ev.fflags & NOTE_ATTRIB) {
                        printf("chmod/chown/utimes ");
                        ev.fflags &= ~NOTE_ATTRIB;
                }
                if (ev.fflags & NOTE_LINK) {
                        printf("hardlinked ");
                        ev.fflags &= ~NOTE_LINK;
                }
                if (ev.fflags & NOTE_RENAME) {
                        printf("renamed ");
                        ev.fflags &= ~NOTE_RENAME;
                }
                if (ev.fflags & NOTE_REVOKE) {
                        printf("revoked ");
                        ev.fflags &= ~NOTE_REVOKE;
                }
                printf("\n");
                if (ev.fflags)
                        warnx("unknown event 0x%x\n", ev.fflags);
        }
}