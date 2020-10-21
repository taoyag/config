setlocal shiftwidth=4
setlocal tabstop=4

if filereadable("./gradlew")
    let test#java#runner = 'gradletest'
    let test#java#gradletest#executable = './gradlew test'
endif
let test#strategy = "neovim"
