using System;
using System.Collections.Generic;
using static System.String;
using System.Linq;
using System.IO;
using System.Text;

class Program
{
    static Dictionary<string, string> InstOpcode;
    static Dictionary<string, string> RegAddr;
    static List<string> ResultList;
    

    static void Main()
    {
        ResultList = new List<string>();
        InstOpcode = new Dictionary<string, string>(){
            {"Sub", "0010"},
            {"Addi", "0011"},
            {"And", "0101"},
            {"Sll", "0110"},
            {"Lw", "0111"},
            {"Sw", "1001"},
            {"CLR", "1011"},
            {"Mov", "1100"},
            {"CMP", "1101"},
            {"Bne", "1110"},
            {"Jmp", "1111"}
        };
        RegAddr = new Dictionary<string, string>(){
            {"d0", "0001"},
            {"d1", "0010"},
            {"d2", "0011"},
            {"d3", "0100"},
            {"A0", "0101"},
            {"A1", "0110"},
            {"A2", "0111"},
            {"A3", "1000"},
            {"BA", "1001"},
            {"PC", "1010"},
            {"SR", "1011"},
            {"ZERO", "0000"},
        };
        string pathForRead = @"E:\JOZVEH\CA\Project\Textfile.txt";
        var Lines = File.ReadLines(pathForRead);
        for (int i = 0; i < Lines.Count(); i++)
        {
            Convertor(Lines.ElementAt(i));
        }
        
        string path = @"E:\JOZVEH\CA\Project\result.txt";
        using (StreamWriter writer = new StreamWriter(path))
        {
            for (int i = 0; i < ResultList.Count; i++)
            {
                writer.WriteLine(ResultList[i]);
            }
        }
        
    }

    static void Convertor(string line)
    {
        var l1 = line.Split(' ');
        l1[1] = l1[1].Replace(',', ' ').TrimEnd();
        if (l1[0] == "Add")
        {
            if (int.TryParse(l1[2], out int result))
            {
                string immediate = Convert.ToString(int.Parse(l1[2]), 2);
                I_Format("0001", l1[1], immediate);
            }
            else
            {
                R_Format("0000", l1[1], l1[2]);
            }
        }
        else if (l1[0] == "Sub" || l1[0] == "And" || l1[0] == "CMP")
        {
            string op = string.Empty;
            bool a = InstOpcode.TryGetValue(l1[0], out op);
            R_Format(op, l1[1], l1[2]);
        }
        else if (l1[0] == "Lw" || l1[0] == "Sw" || l1[0] == "Mov" || l1[0] == "Addi" || l1[0] == "Sll")
        {
            string op = string.Empty;
            bool a = InstOpcode.TryGetValue(l1[0], out op);
            string immediate = Convert.ToString(int.Parse(l1[2]), 2);
            I_Format(op, l1[1], immediate);
        }
        else if (l1[0] == "Bne" || l1[0] == "Jmp")
        {
            string op = string.Empty;
            bool a = InstOpcode.TryGetValue(l1[0], out op);
            J_Format(op, l1[1]);
        }
        else if (l1[0] == "CLR")
        {
            if (int.TryParse(l1[1], out int result))
            {
                J_Format("0100", l1[1]);
            }
            else
            {
                string op = string.Empty;
                bool a = InstOpcode.TryGetValue(l1[0], out op);
                I_Format(op, l1[1], "00000000");
            }
        }
    }

    static void J_Format(string opcode, string address)
    {
        StringBuilder s = new StringBuilder();
        s.Append(opcode);
        string binary = Convert.ToString(int.Parse(address), 2);
        while (binary.Length < 12)
        {
            binary = binary.Insert(0, "0");
        }
        s.Append(binary);
        ResultList.Add(s.ToString());
    }

    static void I_Format(string opcode, string rd, string immediate)
    {
        StringBuilder s = new StringBuilder();
        s.Append(opcode);
        string rdcode = string.Empty;
        bool a = RegAddr.TryGetValue(rd, out rdcode);
        s.Append(rdcode);
        while (immediate.Length < 8)
        {
            immediate = immediate.Insert(0, "0");
        }
        s.Append(immediate);
        ResultList.Add(s.ToString());
    }

    static void R_Format(string opcode, string rd, string rs)
    {
        StringBuilder s = new StringBuilder();
        s.Append(opcode);
        string rdcode = string.Empty;
        bool a = RegAddr.TryGetValue(rd, out rdcode);
        s.Append(rdcode);
        string rscode = string.Empty;
        a = RegAddr.TryGetValue(rs, out rscode);
        s.Append(rscode);
        s.Append("0000");
        ResultList.Add(s.ToString());
    }
}