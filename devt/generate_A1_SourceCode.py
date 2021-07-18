#!/usr/local/bin/python3 

# This script creates file 'A1_SourceCode.tex' in current directory (for thesis writing) 

import os 

classes = os.listdir('../src/classes') 
classes = [x for x in classes if x.endswith('.m')]
classes.sort()

funns = os.listdir('../src/functions') + os.listdir('../src/functions/devt')
funns = [x for x in funns if x.endswith('.m')]
funns = funns + ['getSimvmaPath.m', 'initialize.m', 'sl_customization.m']
funns.sort() 

content = """\chapter{Source Code}
\label{chapter:appendix-source-code}

This appendix presents the MATLAB implementation of various classes and functions used in the project.
"""

content += "\n\n\section{Class Definitions}\n\label{section:class-definitions}\n"


for i, x in enumerate(classes):
    # print(x)
    # if i!=0:
    #     content += f"\n\\newpage"
    x = x[:-2] # removing trailing .m 
    x_latex = x.replace('_', '\_')
    content += f"\n\lstinputlisting[caption={{{x_latex}.m class definition}}, captionpos=t,label={{lst:code-{x}}}]{{Codes/classes/{x}.m}}"


content += "\n\n\\newpage\n\section{Function Definitions}\n\label{section:function-definitions}\n"

for i, x in enumerate(funns):
    # print(x)
    # if i!=0:
    #     content += f"\n\\newpage"
    x = x[:-2] # removing trailing .m 
    x_latex = x.replace('_', '\_')
    content += f"\n\lstinputlisting[caption={{{x_latex}.m function definition}}, captionpos=t,label={{lst:code-{x}}}]{{Codes/functions/{x}.m}}"


with open('A1_SourceCode.tex', 'w') as file: 
    file.write(content)