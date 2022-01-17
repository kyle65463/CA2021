module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i; // 23-bit tag + 1 dirty bit + 1 valid bit
input    [255:0]   data_i;
input              enable_i; // cpu_req
input              write_i; // cache_write | (hit & cpu_MemWrite_i)

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;

reg   [24:0]    tag_o;
reg   [255:0]   data_o;
reg             hit_o;

// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

integer            i, j;

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        i = 1'b0;
        tag[addr_i][i] = tag_i;
        data[addr_i][i] = data_i;
    end
end

// Read Data      
always@(tag_i or addr_i or enable_i) begin
    hit_o = 1'b0;
    data_o = 256'b0;
    tag_o = 25'b0;
    if (enable_i) begin
        for (j=0;j<2;j=j+1) begin
            if (tag[addr_i][j][22:0] == tag_i[22:0] && tag[addr_i][j][24]) begin
                hit_o = 1'b1;
                data_o = data[addr_i][j];
                tag_o = tag_i;
            end
        end
    end
end

endmodule
