using System;
using clojure;

namespace app_dotnetcore
{
    class Program
    {
        static void Main(string[] args)
        {
            /*
             .NET Core 3+ dropped support of AssemblyBuilder.Save, which Clojure CLR relies on to build .NET dlls from clojure files
             so the only option to run clojure from .NET Core currently is to load it dynamically (see below)

             You can do the proper clj->dll compilation on .NET Framework 4.6.1+ though
             see:
                https://github.com/clojure/clojure-clr/wiki/Getting-started#getting-an-executable-repl-for-net-framework-461-and-later
                https://github.com/clojure/clojure-clr/blob/master/docs/nuget-for-libs-pre-core.md

             There is some hope that building clojure dlls on .NET Core will soon be available again
             see: 
                https://clojure.atlassian.net/browse/CLJCLR-109
                https://github.com/Lokad/ILPack/issues/164
                
             (pray to David Miller)
            */

            clojure.lang.IFn loadFile= clojure.clr.api.Clojure.var("clojure.core", "load-file");
            loadFile.invoke("../lib-clj/src/common/lib.cljc");

            clojure.lang.IFn require = clojure.clr.api.Clojure.var("clojure.core", "require");
            require.invoke(clojure.clr.api.Clojure.read("common.lib"));

            clojure.lang.IFn hello = clojure.clr.api.Clojure.var("common.lib", "hello");

            var result = hello.invoke("dotnet");

            Console.WriteLine(result);
        }
    }
}
