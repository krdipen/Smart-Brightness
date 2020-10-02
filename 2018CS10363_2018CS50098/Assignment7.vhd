LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;
entity Assignment7 is
port( C : in std_logic;           
		CS : out std_logic;
		SDK : out std_logic;
		SDO : in std_logic;
		LED : out std_logic_vector(15 downto 0);
          A    : out   std_logic_vector(3 downto 0);  
          cathode : out std_logic_vector(0 to 6));     
end Assignment7;
architecture Behavioral of Assignment7 is

signal KHz_clk : std_logic;
signal Hz_clk : std_logic;
signal MHz_clk : std_logic;
signal t : std_logic_vector(3 downto 0);
signal m : integer range 0 to 100000 := 0;
signal n : integer range 0 to 100000000 := 0;
signal p : integer range 0 to 50 := 0;
signal D : std_logic_vector(3 downto 0);
signal tmp : integer range 0 to 2000000 := 0;

signal flag : std_logic;
signal output : std_logic;
begin
-- 1 Hz Clock generation 
  process (C) 
    begin
        if (C'event and C='1') then
            m <= m + 1;
				n <= n+1;
				p <= p+1;
        end if;
       
        if (m=100000) then
            m <= 0;
        end if;
       
        if (m<50000) then
            KHz_clk <= '1';
        else
            KHz_clk <= '0';
        end if;
		  
		  if (n=100000000) then
            n <= 0;
        end if;
       
        if (n<50000) then
            Hz_clk <= '1';
        else
            Hz_clk <= '0';
        end if;
		  -- 1 MHZ - 4MHZ Clock generation  
		  if (p=50) then
            n <= 0;
        end if;
       
        if (p<25) then
            MHz_clk <= '1';
        else
            MHz_clk <= '0';
        end if;
		  
    end process;

	-- SPI Communication
	process(C)
	begin
	 if (C'event and C='1') then
	   if(flag = '1') then
	   SDK <= MHz_clk;
	   end if;
	   if(p=49) then
	   tmp <= tmp+1;
	       if(tmp = 2000000) then
	          tmp <=0;
	       end if;
	   if(tmp>0 and tmp <=15) then 
	       CS <='0';
	       flag <= '1';
	       SDK <= MHz_clk;
	   if(tmp >4 and tmp <=8) then
	   D(8-tmp) <= SDO;
	    end if;
	   else
	   CS<='1';
	   flag <= '0';
	   SDK <= '1';
	    end if;
	 end if;
	 end if;
	end process;

	-- 7 Segment digit display
	process (C)
	begin
	if (C'event and C='1') then
	if( m=99999) then
			CASE D IS
                            WHEN "0000" => cathode <="0000001";
                            WHEN "0001" => cathode <="1001111";
                            WHEN "0010" => cathode <="0010010";
                            WHEN "0011" => cathode <="0000110";
                            WHEN "0100" => cathode <="1001100";
                            WHEN "0101" => cathode <="0100100";
                            WHEN "0110" => cathode <="0100000";
                            WHEN "0111" => cathode <="0001111";
                            WHEN "1000" => cathode <="0000000";
                            WHEN "1001" => cathode <="0000100";
                            WHEN "1010" => cathode <="0001000";
                            WHEN "1011" => cathode <="1100000";
                            WHEN "1100" => cathode <="0110001";
                            WHEN "1101" => cathode <="1000010";
                            WHEN "1110" => cathode <="0110000";
                            WHEN "1111" => cathode <="0111000";
			END CASE;

			if(to_integer(unsigned(t)) < to_integer(unsigned(D)) ) then
				output <= '1';
			else
				output <= '0';
			end if;
			t <= t + 1;
		end if;
if(output ='0') then
	LED <= "0000000000000000";
else
	LED <= "1111111111111111";
A(0) <= '0';
A(1) <= '1';
A(2) <= '1';
A(3) <= '1';
end if;
end if;
   end process;   
	end Behavioral;



