	component pong is
		port (
			aleatorio_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			ana_barra_d_export  : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			ana_barra_e_export  : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			barra_d_y_export    : out std_logic_vector(9 downto 0);                    -- export
			barra_e_y_export    : out std_logic_vector(9 downto 0);                    -- export
			bola_x_export       : out std_logic_vector(9 downto 0);                    -- export
			bola_y_export       : out std_logic_vector(9 downto 0);                    -- export
			busy_export         : out std_logic_vector(7 downto 0);                    -- export
			clk_clk             : in  std_logic                    := 'X';             -- clk
			iniciar_export      : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			lcd_databus         : out std_logic_vector(7 downto 0);                    -- databus
			lcd_operationenable : out std_logic;                                       -- operationenable
			lcd_registerselect  : out std_logic;                                       -- registerselect
			lcd_readwrite       : out std_logic;                                       -- readwrite
			rst_export          : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component pong;

	u0 : component pong
		port map (
			aleatorio_export    => CONNECTED_TO_aleatorio_export,    --   aleatorio.export
			ana_barra_d_export  => CONNECTED_TO_ana_barra_d_export,  -- ana_barra_d.export
			ana_barra_e_export  => CONNECTED_TO_ana_barra_e_export,  -- ana_barra_e.export
			barra_d_y_export    => CONNECTED_TO_barra_d_y_export,    --   barra_d_y.export
			barra_e_y_export    => CONNECTED_TO_barra_e_y_export,    --   barra_e_y.export
			bola_x_export       => CONNECTED_TO_bola_x_export,       --      bola_x.export
			bola_y_export       => CONNECTED_TO_bola_y_export,       --      bola_y.export
			busy_export         => CONNECTED_TO_busy_export,         --        busy.export
			clk_clk             => CONNECTED_TO_clk_clk,             --         clk.clk
			iniciar_export      => CONNECTED_TO_iniciar_export,      --     iniciar.export
			lcd_databus         => CONNECTED_TO_lcd_databus,         --         lcd.databus
			lcd_operationenable => CONNECTED_TO_lcd_operationenable, --            .operationenable
			lcd_registerselect  => CONNECTED_TO_lcd_registerselect,  --            .registerselect
			lcd_readwrite       => CONNECTED_TO_lcd_readwrite,       --            .readwrite
			rst_export          => CONNECTED_TO_rst_export           --         rst.export
		);

