

using Test

import ArgsReform:@reform

@testset let nt_1=(d=4,c=3,b=2,a=1)
    @reform b,rest...=nt_1...
    @test b==2
    @test rest==(d=4,c=3,a=1)
end

@testset let nt_2=(a=1,b=2,c=3),nt_3=(d=5,c=4,b=3)
    @reform b,c,rest...=nt_2...,nt_3...,(f=6)
    @test b==3
    @test c==4
    @test rest==(a=1,d=5,f=6)
end


@testset let
    @reform d, e = (e=2, d=1)... # d == 1, e == 2
    @test d == 1
    @test e == 2
end

@testset let nt_1 = (a=1, b=2, c=3), nt_2 = (a=1, b=2, c=3)
    @reform a, c, nt_1... = nt_1... # a == 1, c == 3, nt_1 == (b=2,)
    @test a == 1
    @test c == 3
    @test nt_1 == (b=2,)

    @reform nt_2... = nt_2..., (d=4) # nt_2 == (a=1, b=2, c=3, d=4)
    @test nt_2 == (a=1, b=2, c=3, d=4)
end

@testset let nt_1 = (a=1, b=2, c=3), nt_2 = (b=4, c=5, d=6)
    @reform b, c, nt_3... = nt_1..., nt_2... # b == 4, c == 5, nt_3 == (a=1, d=6) 
    @test b == 4
    @test c == 5
    @test nt_3 == (a=1, d=6) 
end

@testset let b=2
    @reform nt_1... = (a=1), b # nt_1 == (a=1, b=2)
    @test nt_1 == (a=1, b=2)
end

@testset let nt_1 = (a=1, b=2, c=3)
    @reform a = nt_1... # a == 1, _rest == (b=2, c=3)
    @test a == 1
    @test _rest == (b=2, c=3)
end