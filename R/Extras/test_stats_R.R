if (F) {

dts_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = e = f = numeric(n)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  Gcur = 0
  height = 0
  width = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    Gcur = Gcur+1/n
    sd = (n*Gcur*(1-Gcur))**0.5
    height = abs(Fcur-Ecur)
    width = d[i+1]-d[i]
    if (sd > 0)
      out = out + ((height/sd)**power)*width
  }
  out
}

ks_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    if (d[i] != d[i+1]) height = abs(Fcur-Ecur)
    if (height > out) out = height
  }
  out**power
}

kuiper_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
n2 = length(vec2)
n = n1+n2

joint.sample = c(vec1,vec2)
ee = c(rep(1/n1,n1),rep(0,   n2))
ff = c(rep(0,   n1),rep(1/n2,n2))

ind = order(joint.sample)
d = joint.sample[ind]
e = ee[ind]
f = ff[ind]

up = 0
down = 0
Ecur = 0
Fcur = 0
height = 0
for (i in 1:(n-1)) {
  Ecur = Ecur + e[i]
  Fcur = Fcur + f[i]
  if (d[i] != d[i+1]) height = Fcur-Ecur
  if (height > up) up = height
  if (height < down) down = height
}
abs(down)**power + abs(up)**power
}
cvm_stat_R = function(vec1,vec2,power=2){
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    height = abs(Fcur-Ecur)
    if (d[i] != d[i+1]) out = out + height**power
  }
  out
}
ad_stat_R = function(vec1,vec2,power=2){
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  Gcur = 0
  height = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    Gcur = Gcur+1/n
    sd = (n*Gcur*(1-Gcur))**0.5
    height = abs(Fcur-Ecur)
    if (d[i] != d[i+1])
      if (sd > 0)
        out = out + (height/sd)**power
  }
  out
}
wass_stat_R = function(vec1,vec2,power=1) {
  n1 = length(vec1)
  n2 = length(vec2)
  n = n1+n2

  joint.sample = c(vec1,vec2)
  ee = c(rep(1/n1,n1),rep(0,   n2))
  ff = c(rep(0,   n1),rep(1/n2,n2))

  ind = order(joint.sample)
  d = joint.sample[ind]
  e = ee[ind]
  f = ff[ind]

  out = 0
  Ecur = 0
  Fcur = 0
  height = 0
  width = 0
  for (i in 1:(n-1)) {
    Ecur = Ecur + e[i]
    Fcur = Fcur + f[i]
    height = abs(Fcur-Ecur)
    width = d[i+1]-d[i]
    out = out + (height**power)*width
  }
  out
}


}
