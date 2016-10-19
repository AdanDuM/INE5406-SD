library IEEE;
use IEEE.std_logic_1164.all;
 
-- Alunos: Adan Pereira Gomes e Wesley Mayk Gama Luz
 
 entity switch2x2 is
	 generic(width: integer:= 8);
	 port(
		 in_0	: in std_logic_vector(width-1 downto 0);
		 in_1	: in std_logic_vector(width-1 downto 0);
		 ctrl	: in std_logic_vector(1 downto 0);
		 out_0: out std_logic_vector(width-1 downto 0);
		 out_1: out std_logic_vector(width-1 downto 0)
	 );
 end entity;
 
 architecture circuito of switch2x2 is
 begin
	 outp0 <= inpt0 when ctrl = "00" else
				 inpt1 when ctrl = "01" else
				 inpt0 when ctrl = "10" else
				 inpt1 when ctrl = "11";
	 
	 outp1 <= inpt1 when ctrl = "00" else
				 inpt0 when ctrl = "01" else
				 inpt0 when ctrl = "10" else
				 inpt1 when ctrl = "11";
 end architecture;
