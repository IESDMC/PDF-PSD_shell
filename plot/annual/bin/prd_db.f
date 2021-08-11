	program prd_db
c
c
c
	character*128 inp,out
	narg=IArgC()
	if(narg.ne.1) stop
	call GetArg(1,inp)
	open(1,file=inp)
	open(21,file='tmp.out')

	prd0=0.02
	icount1=0
	do i=1,10000000
	  read(1,*,end=999) prd,db,icount
	  if(icount .gt. icount1) then
	    icount1=icount
	    db1=db
	  end if
	  if(i.ne.1 .and. prd.ne.prd0) then
	     write(21,*) alog10(prd),db1
	     icount1=0
	  end if
	  prd0=prd
	end do
999	close(1)
	close(21)
	stop
	end
