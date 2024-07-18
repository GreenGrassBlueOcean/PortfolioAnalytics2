Test <- function(){
Assets = c("stock1", "stock2", "stock3", "stock4")
Initportfolio <- portfolio.spec(assets=Assets)

# Add the full investment constraint that specifies the weights must sum to 1
Initportfolio <- add.constraint(portfolio=Initportfolio, type = "leverage", min_sum = 0.98, max_sum = 1.02)
 if (length(Assets) > 10){
   Initportfolio <- add.constraint(portfolio=Initportfolio, type = "box", min = 0, max = 0.2)
 } else {
   Initportfolio <- add.constraint(portfolio=Initportfolio, type = "box", min = 0, max = 1)
}


 NoLimit <- random_portfolios_v2( portfolio = Initportfolio, permutations = 100
                                            , rp_method = "sample", eliminate = TRUE

 )


Initportfolio <- add.constraint(portfolio=Initportfolio, type = "position_limit", max_pos_long = 70)


PositionLimit <- random_portfolios_v2( portfolio = Initportfolio, permutations = 100
                                             , rp_method = "sample", eliminate = TRUE

)

return(list("PositionLimit" = PositionLimit, "NoLimit" = NoLimit))
}
