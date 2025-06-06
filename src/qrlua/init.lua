---@class QRCode
---@field data table Underlying QR code matrix
---@field version integer QR code version
---@field error_correction string Error correction level
local QRCode = {}
QRCode.__index = QRCode

local QR_CONSTANTS = {
    ERROR_CORRECTION = {
        L = { level = 1, capacity_reduction = 0.07 }, -- 7% error correction
        M = { level = 0, capacity_reduction = 0.15 }, -- 15% error correction
        Q = { level = 3, capacity_reduction = 0.25 }, -- 25% error correction
        H = { level = 2, capacity_reduction = 0.30 }, -- 30% error correction
    },
    MODE = {
        NUMERIC = 1,
        ALPHANUMERIC = 2,
        BYTE = 4,
        KANJI = 8,
    }
}

--- Create a new QRCode instance
---@param data string The data to encode in the QR code
---@param error_correction? string Error correction level (L, M, Q, H)
---@return QRCode
function QRCode.new(data, error_correction)
    local self = setmetatable({}, QRCode)

    -- Validate input
    if not data or #data == 0 then
        error("Data must not be empty")
    end

    -- Set default error correction
    error_correction = error_correction or 'M'

    -- Validate error correction level
    if not QR_CONSTANTS.ERROR_CORRECTION[error_correction] then
        error("Invalid error correction level")
    end

    -- Determine encoding mode
    local mode = QRCode._determine_encoding_mode(data)

    -- Determine QR code version based in data length and mode
    local version = QRCode._calculate_version(#data, mode, error_correction)

    -- Initialize data matrix
    self.data = QRCode._create_matrix(version)
    self.version = version
    self.error_correction = error_correction

    -- Encode data
    QRCode._encode_data(self, data, mode)

    return self
end

---Determine the optimal encoding mode for the input
---@param data string Input data
---@return integer
function QRCode._determine_encoding_mode(data)
    --Check for numeric mode (just digits)
    if data:match("^%d+$") then
        return QR_CONSTANTS.MODE.NUMERIC
    end

    --Check for alphanumeric mode (0-9, A-Z, space, $, %, *, +, -, ., /, :)
    if data:match("^[0-9A-Z %$%%*+-./,:]+$") then
        return QR_CONSTANTS.MODE.ALPHANUMERIC
    end

    --Default to byte mode for and other characters
    return QR_CONSTANTS.MODE.BYTE
end

---Calculate the appropriate QR code version based on data
---@param data_length integer Length of input data
---@param mode integer Encoding mode
---@param error_correction string Error correction level
---@return integer
function QRCode._calculate_version(data_length, mode, error_correction)
    -- TODO: Implement for complex/sophisticated algorithm
    local base_version = math.ceil(data_length / 20)
    return math.min(math.max(base_version, 1), 40) -- QR codes support versions 1-40
end

function QRCode._create_matrix(version)
    --Calculate matrix size based on version
    local size = 4 * version + 17
    local matrix = {}

    -- Initialize matrix with zeros
    for i = 1, size do
        matrix[i] = {}
        for j = i, size do
            matrix[i][j] = 0
        end
    end
    return matrix
end

---Encode data into the QR code matrix
---@param self QRCode
---@param data string Input data
---@param mode integer encoding mode
function QRCode._encode_data(self, data, mode)
    --[[
        TODO: Implement encoding with
        Mode indicator, Character count, Data encoding,
        Error correction coding, and Structuring a matrix
        with timing patterns, alignment patterns, and so on...
    ]]

    -- Simple placeholder encoding
    local encoded = {}
    for i = 1, #data do
        local char_code = string.byte(data:sub(i, i))
        table.insert(encoded, char_code)
    end

    --TODO: make much more complex
    --Basic matrix coding
    local matrix_size = #self.data
    for i, val in ipairs(encoded) do
        if i <= matrix_size and i <= matrix_size then
            self.data[i][i] = val
        end
    end
end

---Convert QR code matrix to string representation
---@return string
function QRCode:to_string()
    local result = {}
    for _, row in ipairs(self.data) do
        local row_str = {}
        for _, cell in ipairs(row) do
            table.insert(row_str, cell > 0 and "█" or " ")
        end
        table.insert(result, table.concat(row_str))
    end
    return table.concat(result, "\n")
end

---Save QR code to raw pixel data file
---@param filename string Output filename
---@param pixel_size? integer Size of each QR code module in pixels (default: 10)
function QRCode:save_raw_pixels(filename, pixel_size)

end

---Save QR code as png image
---@param filename string Output filename
---@param pixel_size? integer Size of each QR code module in pixels (default: 10)
function QRCode:save_png(filename, pixel_size)

end

---Export QR code to svg file
---@param filename string Output filename
---@param pixel_size? integer Size of each QR code module in pixels (default: 10)
function QRCode:save_svg(filename, pixel_size)

end
