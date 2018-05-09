module ThreadTest

	mutable struct Model 
		a::Vector
		id::Vector{Int}
	end

	mutable struct LModel
		b::Vector
	end

	function doit(n=10)
		m = Model(zeros(n),zeros(Int,n))
		Threads.@threads for i in 1:n
			dothread!(m,i)
		end
		return m
	end

	function dothread!(m::Model,i::Int)
		Lm = LModel(rand(1_000))  # create a local model

		# do some work on the local model and store the results in 
		# the global model array
		m.a[i] = median(Lm.b)
		m.id[i] = Threads.threadid()  # note which id did which slot
	end

end # module
