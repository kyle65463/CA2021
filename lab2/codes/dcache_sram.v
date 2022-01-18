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
reg      [1:0]     last[0:15];    

integer            i, j, found;
integer            outfile;

initial begin
    outfile = $fopen("test.txt");
end

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    $fdisplay(outfile, "clk");
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            last[i] <= 2'b0;
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // Find if the block is in the cache first
        found = 1'b0;
        for (j=0;j<2;j=j+1) begin
            if (tag[addr_i][j][22:0] == tag_i[22:0] && tag[addr_i][j][24]) begin
                $fdisplay(outfile, "write hit");
                tag[addr_i][j] = tag_i;
                tag[addr_i][j][23] = 1'b1;
                data[addr_i][j] = data_i;
                found = 1'b1;
                last[addr_i] = j + 1; // 01 or 10
            end
        end

        // Replace the least recent used block if not found
        if (!found) begin
            // $fdisplay(outfile, "not found");
            if (last[addr_i] == 2'b00 || last[addr_i] == 2'b10) begin
                // Replace the first block
                tag[addr_i][0] = tag_i;
                tag[addr_i][0][23] = 1'b0;
                tag[addr_i][0][24] = 1'b1;
                data[addr_i][0] = data_i;
                last[addr_i] = 2'b01;
            end
            else begin
                // Replace the second block
                tag[addr_i][1] = tag_i;
                tag[addr_i][1][23] = 1'b0;
                tag[addr_i][1][24] = 1'b1;
                data[addr_i][1] = data_i;
                last[addr_i] = 2'b10;
            end
        end
        $fdisplay(outfile, "%b %b", tag[addr_i][0], tag[addr_i][1]);
        $fdisplay(outfile, "%h %h", data[addr_i][0], data[addr_i][1]);
    end
end

// Read Data      
always@(tag_i or addr_i or enable_i or tag[addr_i][0] or tag[addr_i][1] or data[addr_i][0] or data[addr_i][1]) begin
    hit_o = 1'b0;
    data_o = 256'b0;
    tag_o = 25'b0;
    if (enable_i) begin
        found = 1'b0; 
        for (j=0;j<2;j=j+1) begin
            if (tag[addr_i][j][22:0] == tag_i[22:0] && tag[addr_i][j][24]) begin
                hit_o = 1'b1;
                data_o = data[addr_i][j];
                tag_o = tag[addr_i][j];
                found = 1'b1;
                last[addr_i] = j + 1; // 01 or 10
            end
        end

        if (!found) begin
            // $fdisplay(outfile, "not found");
            if (last[addr_i] == 2'b00 || last[addr_i] == 2'b10) begin
                // Replace the first block
                data_o = data[addr_i][0];
                tag_o = tag[addr_i][0];
            end
            else begin
                // Replace the second block
                data_o = data[addr_i][1];
                tag_o = tag[addr_i][1];
            end
        end
    end
end

endmodule
