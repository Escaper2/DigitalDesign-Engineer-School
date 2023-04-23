using System;
using System.Text;

namespace TextAnalyzer
{
    internal class Program
    {
        static void Main()
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);


            Console.WriteLine("Please enter name of the file (without .txt)");

            var name = Console.ReadLine();

            if (name is null) throw new ArgumentNullException();

            var textProcessor = new TextProcessor(name);

            textProcessor.Run();
        }
    }
}