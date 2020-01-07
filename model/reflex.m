function PP = reflex(b, d, t)

PP = 1 + d * ((t.*exp(0.5))./b .* exp(-t.^2  ./(2*b^2)) );