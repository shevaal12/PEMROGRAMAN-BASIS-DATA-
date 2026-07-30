# PEMROGRAMAN-BASIS-DATA-
**Database db_repair_shop ** dibuat untuk membantu bengkel servis elektronik dalam mengelola berbagai aktivitas sehari-hari. Database ini menyimpan data penting seperti informasi pelanggan, teknisi, perangkat yang diperbaiki, transaksi servis, serta penggunaan sparepart.
Ada beberapa tabel utama di dalamnya, yaitu:
**Pelanggan: menyimpan data pengguna jasa servis.**
**Teknisi: berisi informasi teknisi yang melakukan perbaikan.**
**Servis: mencatat semua transaksi perbaikan, mulai dari perangkat yang masuk hingga status pengerjaan.**
**Sparepart dan Detail Servis: mengelola penggunaan suku cadang dalam setiap proses servis.**

Database ini juga menghubungkan data antar tabel dengan menggunakan kunci utama (primary key) dan kunci asing (foreign key). Misalnya, satu pelanggan bisa memiliki banyak riwayat servis, dan satu transaksi servis bisa memakai beberapa sparepart yang tercatat di detail servis.Selain itu, database ini punya fitur tambahan seperti stored procedure, function, trigger, dan view. Stored procedure membantu mempermudah pencarian data servis, function berguna untuk menghitung jumlah servis dan total biaya. Trigger berfungsi menjalankan proses otomatis, seperti mencatat log saat ada transaksi baru.Dengan adanya database ini, operasional bengkel jadi lebih teratur dan efisien. Informasi tersimpan dengan aman, mudah dicari, dan bisa digunakan untuk membuat laporan dengan lebih cepat dan tepat.Singkatnya, db_repair_shop membantu bengkel mengelola pelanggan, teknisi, servis, dan stok sparepart secara terstruktur dan praktis.
