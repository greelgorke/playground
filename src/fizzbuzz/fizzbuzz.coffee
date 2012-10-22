m=['fizz','buzz'];(m[v]=''for v in[-1..-4]);m[-i%3]+m[-i%5||1]||i for i in[1..100]

f=['fizz'];b=['buzz'];[i,f[i%3],b[i%5]].join('')for i in[1..100]

[['fizz'][i%3],['buzz'][i%5]].join('')||i for i in[1..100]
[i,['fizz'][i%3],['buzz'][i%5]].join('')for i in[1..100]
