module ThreadTest

	mutable struct Model 
		a::Vector{Float64}
		r::Vector{Float64}
		id::Vector{Int}
	end

	mutable struct LModel
		b::Array
		function LModel(i::Int)
			new(ones(10,10))
		end
	end

	function doit0(n=10)
		m = Model(zeros(n),zeros(n),zeros(Int,n))
		Threads.@threads for i in 1:n
			z=ThreadTest.dothread!(m,i)
		end
		return m
	end

	function doit1(n=10)
		m = Model(zeros(n),rand(n),zeros(Int,n))
		x = 1.3
		Threads.@threads for i in 1:n
			Lm = LModel(i)  # create a local model
			lx = x + i
			id = Threads.threadid()  # note which id did which slot
			m.id[i] = id  # note which id did which slot
			m.a[i] = mean(Lm.b .* id) 
		end
		return m,hcat(m.a,m.id)
	end
	function doit2()
		a = zeros(Int,10)
		y = zeros(10)
		x = 1.3
		Threads.@threads for i = 1:10
			lx = x + i
            a[i] = Threads.threadid()
            y[i] = lx
   		end
   		return (a,y)
	end

	function dothread!(m::Model,i::Int)
		Lm = LModel(i)  # create a local model
		# do some work on the local model and store the results in 
		# the global model array
		# tmp = [Threads.threadid() for i in 1:14]
		m.id[i] = Threads.threadid()  # note which id did which slot
		m.a[i] = mean(Lm.b .* m.id[i] ) 
		m.r[i] = rand()
	end

end # module
