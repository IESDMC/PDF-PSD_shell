	program noisepower
c
c       a program to calculte the total power (kinetic envergy) of
c       ambient noise in a specific period range
c
c       Wen-Tzong Liang
c       DMC-IES, Academia Sinica
c       2012/02/12
c
        character*80 inp_file,out_file,arg

        nargc=IArgC()
        if(nargc .ne. 4) then
          print *
          print *,'Usage: noisePower [inpfile] [outfile] [prd0] [prd1]'
          print *,'Ex.: noisePower test.inp test.out 2 8'
          print *,'     obtain power between periods of 2 and 8 sec'
          print *
          stop
        endif

        call getarg(1,inp_file)
        call getarg(2,out_file)
        call getarg(3,arg)
        read(arg,*) p0
        call getarg(4,arg)
        read(arg,*) p1

	open(1,file=inp_file)
        open(21,file=out_file)

c        print *,'Input period range [Pmin Pmax]:'
c        read(*,*) p0,p1
        p0=alog10(p0)
        p1=alog10(p1)
        print *,p0,p1

        sqrt2=sqrt(2.0)

        twopi=2.*3.14159265358979
        t0=1e30
        prd0=1e30
        prd1=-1e30
        sum=0.0
	do i = 1,100000000
	  read(1,*,end=100) t,prdl,db
          if(i.ne.1 .and. t.ne.t0) then
            write(21,*) t0,sum
            sum=0.0
          end if
          if(prdl.ge.p0 .and. prdl.le.p1) then
            Tc=10**prdl
            w=twopi/Tc
c           Ts=Tc/sqrt2
c           Tl=Tc*sqrt2
	    pwr=10**(db/10.)/w/w 
c           convert acceleration power into velocity power
            prd0=amin1(prd0,Tc)
            prd1=amax1(prd1,Tc)
	    sum=sum+pwr
          endif
          t0=t
	end do

100     write(21,*) t,sum

        print *,'Period range in Tc: ',prd0,prd1
        print *,'      in Ts and Tl: ',prd0/sqrt2,prd1*sqrt2
        close(1)
        close(21)
	stop
	end
