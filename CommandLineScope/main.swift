//
//  main.swift
//  CommandLineScope
//
//  Created by 전병학 on 22/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

//print("Hello, World! Command Line Scope")

let scopeShell = ScopeShell()

if CommandLine.argc < 2 { // without argument
    scopeShell.interactiveMode()
} else { // with argument
    scopeShell.staticMode()
}

