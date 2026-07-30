-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 30, 2026 at 03:19 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_repair_shop`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cari_servis` (IN `id_teknisi` INT, IN `status_servis` VARCHAR(20))   BEGIN
    IF status_servis = 'Selesai' THEN
        SELECT
            s.id,
            p.nama AS pelanggan,
            s.jenis_perangkat,
            s.status,
            s.total_biaya
        FROM servis s
        JOIN pelanggan p
        ON s.pelanggan_id = p.id
        WHERE s.teknisi_id = id_teknisi
        AND s.status = status_servis;
    ELSE
        SELECT
            s.id,
            p.nama AS pelanggan,
            s.jenis_perangkat,
            s.status,
            s.total_biaya
        FROM servis s
        JOIN pelanggan p
        ON s.pelanggan_id = p.id
        WHERE s.teknisi_id = id_teknisi;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampil_data_servis` ()   BEGIN
    SELECT 
        s.id AS id_servis,
        p.nama AS nama_pelanggan,
        t.nama AS nama_teknisi,
        s.jenis_perangkat,
        s.status,
        s.total_biaya
    FROM servis s
    JOIN pelanggan p
    ON s.pelanggan_id = p.id
    JOIN teknisi t
    ON s.teknisi_id = t.id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `jumlah_servis` () RETURNS INT DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT COUNT(*)
    INTO total
    FROM servis;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_biaya_servis` (`id_pelanggan` INT, `status_servis` VARCHAR(20)) RETURNS INT DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT SUM(total_biaya)
    INTO total
    FROM servis
    WHERE pelanggan_id = id_pelanggan
    AND status = status_servis;
    RETURN IFNULL(total,0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_servis`
--

CREATE TABLE `detail_servis` (
  `servis_id` int NOT NULL,
  `sparepart_id` int NOT NULL,
  `jumlah` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `detail_servis`
--

INSERT INTO `detail_servis` (`servis_id`, `sparepart_id`, `jumlah`) VALUES
(1, 2, 1),
(1, 5, 1),
(2, 4, 1),
(3, 1, 2),
(4, 9, 1),
(5, 6, 1),
(6, 3, 1),
(7, 4, 1),
(8, 8, 1),
(9, 10, 2),
(11, 2, 1);

--
-- Triggers `detail_servis`
--
DELIMITER $$
CREATE TRIGGER `update_total_servis` AFTER INSERT ON `detail_servis` FOR EACH ROW BEGIN
    DECLARE harga_part INT;
    SELECT harga
    INTO harga_part
    FROM sparepart
    WHERE id = NEW.sparepart_id;
    UPDATE servis
    SET total_biaya =
    total_biaya + (harga_part * NEW.jumlah)
    WHERE id = NEW.servis_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_servis`
--

CREATE TABLE `log_servis` (
  `id_log` int NOT NULL,
  `id_servis` int DEFAULT NULL,
  `aksi` varchar(50) DEFAULT NULL,
  `waktu` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `log_servis`
--

INSERT INTO `log_servis` (`id_log`, `id_servis`, `aksi`, `waktu`) VALUES
(1, 11, 'Data servis baru ditambahkan', '2026-07-25 13:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `member_card`
--

CREATE TABLE `member_card` (
  `id` int NOT NULL,
  `pelanggan_id` int DEFAULT NULL,
  `level` varchar(20) DEFAULT NULL,
  `tanggal_daftar` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `member_card`
--

INSERT INTO `member_card` (`id`, `pelanggan_id`, `level`, `tanggal_daftar`) VALUES
(1, 1, 'Gold', '2025-01-10'),
(2, 2, 'Silver', '2025-01-15'),
(3, 3, 'Gold', '2025-02-01'),
(4, 4, 'Basic', '2025-02-10'),
(5, 5, 'Silver', '2025-02-15'),
(6, 6, 'Gold', '2025-03-01'),
(7, 7, 'Basic', '2025-03-05'),
(8, 8, 'Silver', '2025-03-10'),
(9, 9, 'Gold', '2025-03-15'),
(10, 10, 'Basic', '2025-03-20');

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `nama`, `no_hp`, `kota`) VALUES
(1, 'Andi Saputra', '081234567891', 'Yogyakarta'),
(2, 'Budi Santoso', '081234567892', 'Sleman'),
(3, 'Citra Lestari', '081234567893', 'Bantul'),
(4, 'Doni Pratama', '081234567894', 'Solo'),
(5, 'Eka Wijaya', '081234567895', 'Klaten'),
(6, 'Fajar Ramadhan', '081234567896', 'Magelang'),
(7, 'Gilang Putra', '081234567897', 'Jogja'),
(8, 'Hendra Kurnia', '081234567898', 'Semarang'),
(9, 'Intan Sari', '081234567899', 'Purworejo'),
(10, 'Joko Susilo', '081234567890', 'Wonosari'),
(11, 'Kurniawan Pratama', NULL, 'Yogyakarta');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_servis`
--

CREATE TABLE `riwayat_servis` (
  `id` int NOT NULL,
  `pelanggan_id` int DEFAULT NULL,
  `tanggal_servis` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `riwayat_servis`
--

INSERT INTO `riwayat_servis` (`id`, `pelanggan_id`, `tanggal_servis`, `status`) VALUES
(1, 1, '2025-01-10', 'Selesai'),
(2, 2, '2025-01-15', 'Proses'),
(3, 3, '2025-02-01', 'Selesai');

-- --------------------------------------------------------

--
-- Table structure for table `servis`
--

CREATE TABLE `servis` (
  `id` int NOT NULL,
  `pelanggan_id` int DEFAULT NULL,
  `teknisi_id` int DEFAULT NULL,
  `tanggal_masuk` date DEFAULT NULL,
  `jenis_perangkat` varchar(50) DEFAULT NULL,
  `status` enum('Antrian','Proses','Selesai','Batal') DEFAULT 'Antrian',
  `total_biaya` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `servis`
--

INSERT INTO `servis` (`id`, `pelanggan_id`, `teknisi_id`, `tanggal_masuk`, `jenis_perangkat`, `status`, `total_biaya`) VALUES
(1, 1, 1, '2025-04-01', 'Laptop', 'Selesai', 800000),
(2, 2, 2, '2025-04-02', 'Smartphone', 'Proses', 700000),
(3, 3, 3, '2025-04-03', 'Komputer', 'Selesai', 900000),
(4, 4, 4, '2025-04-04', 'Printer', 'Antrian', 400000),
(5, 5, 5, '2025-04-05', 'Tablet', 'Proses', 500000),
(6, 6, 6, '2025-04-06', 'Laptop', 'Selesai', 1000000),
(7, 7, 7, '2025-04-07', 'Smartphone', 'Selesai', 750000),
(8, 8, 8, '2025-04-08', 'Komputer', 'Proses', 850000),
(9, 9, 9, '2025-04-09', 'Printer', 'Selesai', 600000),
(10, 10, 10, '2025-04-10', 'Laptop', 'Antrian', 500000),
(11, 1, 2, '2025-05-01', 'Laptop', 'Antrian', 650000);

--
-- Triggers `servis`
--
DELIMITER $$
CREATE TRIGGER `after_insert_servis` AFTER INSERT ON `servis` FOR EACH ROW BEGIN
    INSERT INTO log_servis
    (id_servis,aksi)
    VALUES
    (NEW.id,
    'Data servis baru ditambahkan');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sparepart`
--

CREATE TABLE `sparepart` (
  `id` int NOT NULL,
  `nama_sparepart` varchar(100) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `harga` int DEFAULT NULL,
  `stok` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sparepart`
--

INSERT INTO `sparepart` (`id`, `nama_sparepart`, `kategori`, `harga`, `stok`) VALUES
(1, 'RAM 8GB', 'Komputer', 450000, 20),
(2, 'SSD 512GB', 'Laptop', 650000, 15),
(3, 'Baterai Laptop', 'Laptop', 550000, 10),
(4, 'LCD Smartphone', 'Smartphone', 700000, 8),
(5, 'Keyboard Laptop', 'Laptop', 300000, 25),
(6, 'Charger HP', 'Smartphone', 150000, 30),
(7, 'Mouse Wireless', 'Komputer', 100000, 40),
(8, 'Harddisk 1TB', 'Komputer', 500000, 12),
(9, 'Printer Head', 'Printer', 400000, 10),
(10, 'Kabel Data', 'Smartphone', 50000, 50);

-- --------------------------------------------------------

--
-- Table structure for table `teknisi`
--

CREATE TABLE `teknisi` (
  `id` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `spesialisasi` varchar(50) DEFAULT NULL,
  `status` enum('Aktif','Cuti','Resign') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `teknisi`
--

INSERT INTO `teknisi` (`id`, `nama`, `spesialisasi`, `status`) VALUES
(1, 'Rizky Maulana', 'Laptop', 'Aktif'),
(2, 'Agus Setiawan', 'Smartphone', 'Aktif'),
(3, 'Dimas Arya', 'Komputer', 'Aktif'),
(4, 'Reza Kurnia', 'Printer', 'Cuti'),
(5, 'Yoga Pratama', 'Tablet', 'Aktif'),
(6, 'Arif Nugroho', 'Laptop', 'Aktif'),
(7, 'Bagas Putra', 'Smartphone', 'Aktif'),
(8, 'Fauzan Hadi', 'Komputer', 'Aktif'),
(9, 'Rendi Saputra', 'Printer', 'Aktif'),
(10, 'Wahyu Setyo', 'Laptop', 'Aktif');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_data_pelanggan`
-- (See below for the actual view)
--
CREATE TABLE `view_data_pelanggan` (
`id` int
,`nama` varchar(100)
,`kota` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_pelanggan_yogyakarta`
-- (See below for the actual view)
--
CREATE TABLE `view_pelanggan_yogyakarta` (
`id` int
,`nama` varchar(100)
,`kota` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_servis_selesai`
-- (See below for the actual view)
--
CREATE TABLE `view_servis_selesai` (
`id` int
,`pelanggan_id` int
,`teknisi_id` int
,`tanggal_masuk` date
,`jenis_perangkat` varchar(50)
,`status` enum('Antrian','Proses','Selesai','Batal')
,`total_biaya` int
);

-- --------------------------------------------------------

--
-- Structure for view `view_data_pelanggan`
--
DROP TABLE IF EXISTS `view_data_pelanggan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_data_pelanggan`  AS SELECT `pelanggan`.`id` AS `id`, `pelanggan`.`nama` AS `nama`, `pelanggan`.`kota` AS `kota` FROM `pelanggan``pelanggan`  ;

-- --------------------------------------------------------

--
-- Structure for view `view_pelanggan_yogyakarta`
--
DROP TABLE IF EXISTS `view_pelanggan_yogyakarta`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_pelanggan_yogyakarta`  AS SELECT `view_data_pelanggan`.`id` AS `id`, `view_data_pelanggan`.`nama` AS `nama`, `view_data_pelanggan`.`kota` AS `kota` FROM `view_data_pelanggan` WHERE (`view_data_pelanggan`.`kota` = 'Yogyakarta') WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `view_servis_selesai`
--
DROP TABLE IF EXISTS `view_servis_selesai`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_servis_selesai`  AS SELECT `servis`.`id` AS `id`, `servis`.`pelanggan_id` AS `pelanggan_id`, `servis`.`teknisi_id` AS `teknisi_id`, `servis`.`tanggal_masuk` AS `tanggal_masuk`, `servis`.`jenis_perangkat` AS `jenis_perangkat`, `servis`.`status` AS `status`, `servis`.`total_biaya` AS `total_biaya` FROM `servis` WHERE (`servis`.`status` = 'Selesai')  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_servis`
--
ALTER TABLE `detail_servis`
  ADD PRIMARY KEY (`servis_id`,`sparepart_id`),
  ADD KEY `sparepart_id` (`sparepart_id`);

--
-- Indexes for table `log_servis`
--
ALTER TABLE `log_servis`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `member_card`
--
ALTER TABLE `member_card`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pelanggan_id` (`pelanggan_id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_kontak_pelanggan` (`nama`,`no_hp`),
  ADD KEY `idx_pelanggan_kota` (`nama`,`kota`);

--
-- Indexes for table `riwayat_servis`
--
ALTER TABLE `riwayat_servis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_riwayat` (`pelanggan_id`,`tanggal_servis`);

--
-- Indexes for table `servis`
--
ALTER TABLE `servis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pelanggan_id` (`pelanggan_id`),
  ADD KEY `teknisi_id` (`teknisi_id`),
  ADD KEY `idx_servis_status_tanggal` (`status`,`tanggal_masuk`);

--
-- Indexes for table `sparepart`
--
ALTER TABLE `sparepart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teknisi`
--
ALTER TABLE `teknisi`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `log_servis`
--
ALTER TABLE `log_servis`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `member_card`
--
ALTER TABLE `member_card`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `riwayat_servis`
--
ALTER TABLE `riwayat_servis`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `servis`
--
ALTER TABLE `servis`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sparepart`
--
ALTER TABLE `sparepart`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `teknisi`
--
ALTER TABLE `teknisi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_servis`
--
ALTER TABLE `detail_servis`
  ADD CONSTRAINT `detail_servis_ibfk_1` FOREIGN KEY (`servis_id`) REFERENCES `servis` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_servis_ibfk_2` FOREIGN KEY (`sparepart_id`) REFERENCES `sparepart` (`id`);

--
-- Constraints for table `member_card`
--
ALTER TABLE `member_card`
  ADD CONSTRAINT `member_card_ibfk_1` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `servis`
--
ALTER TABLE `servis`
  ADD CONSTRAINT `servis_ibfk_1` FOREIGN KEY (`pelanggan_id`) REFERENCES `pelanggan` (`id`),
  ADD CONSTRAINT `servis_ibfk_2` FOREIGN KEY (`teknisi_id`) REFERENCES `teknisi` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
