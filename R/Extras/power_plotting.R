if (F) {
library(tidyverse)
library(ggplot2)

load("dts_sims.RData")

test_cleaner = function(test,alt="PLACEHOLDER") {
  test = gather(test,key="Test",value="power",ks,kuiper,ad,cvm,wass,dts,starts_with(alt))
  test$DTS = test$Test == "dts"
  test$Test = fct_relabel(fct_rev(fct_reorder(test$Test,test$power,mean)),toupper)
  test
}

test1 = test_cleaner(test1,"t.")
test2 = test_cleaner(test2,"f.")
test3 = test_cleaner(test3,"t.")
test4 = test_cleaner(test4,"f.")
test2a = test_cleaner(test2a,"t.")
test5 = test_cleaner(test5,"t.")
test6 = test_cleaner(test6,"t.")
test7 = test_cleaner(test7,"t.")

test_plotter = function(test,xvar="nobs",
                        xlabs="Number of Observations") {
  ggplot(test,aes_string(x=xvar,y="power"))+
    geom_line(aes(color=Test),lwd=0.9,alpha=0.8)+
    geom_point(aes(alpha=DTS),shape=16)+
    geom_hline(yintercept=0.05,lty=2,alpha=0.5)+
    xlab(xlabs)+ylab("% Rejected")
}


test_plotter(test1)
test_plotter(test2)
test_plotter(test3,"mu2","Difference in Means")
test_plotter(test4,"sig2","Ratio of Standard Deviations")
test_plotter(test2a)
test_plotter(test5)
test_plotter(test6)

test7 = test7 %>% filter(nobs < 3000) # All hit 100% by then.
test_plotter(test7)


#---------------------------------------------
#              Experimental!
#---------------------------------------------

#Looking relative to t.test.
test1 %>% select(nobs,Test,power) %>% spread(Test,power) %>% mutate_at(-1,~./T.TEST) %>% gather("Test","power",-nobs) %>% mutate(Test=fct_rev(fct_reorder(Test,power,min))) %>% ggplot(aes(x=nobs,col=Test,y=power)) +geom_line()+ylab("Relative Power Loss")+xlab("Sample Size")


test2 %>% select(nobs,Test,power) %>% spread(Test,power) %>% mutate_at(-1,~./F.TEST) %>% gather("Test","power",-nobs) %>% mutate(Test=fct_rev(fct_reorder(Test,power,min))) %>% ggplot(aes(x=nobs,col=Test,y=power)) +geom_line()+ylab("Relative Power Loss")+xlab("Sample Size")

}
