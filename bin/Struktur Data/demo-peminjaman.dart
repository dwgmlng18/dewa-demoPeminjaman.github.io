class Item {
  String name;
  bool isBorrowed;

  Item(this.name, this.isBorrowed);

  @override
  String toString() => 'Nama Barang: $name, Status Peminjaman: ${isBorrowed ? "Dipinjam" : "Tersedia"}';
}

class Inventory {
  List<Item> items = []; 
  int top = -1; 
  int maxStack;
  List<String> borrowedItemsStack; 

  Inventory(this.maxStack)
      : borrowedItemsStack = List<String>.filled(maxStack, "", growable: false);

  void addItem(String name) {
    items.add(Item(name, false));
    print('Nama barang "$name" berhasil ditambahkan ke program.');
  }

  void borrowItem(String name) {
    int index = _binarySearch(name);
    if (index != -1 && !items[index].isBorrowed) {
      items[index].isBorrowed = true;
      _push(name);
      print('Nama barang "$name" berhasil dipinjam.');
    } else {
      print('Nama barang "$name" tidak tersedia untuk dipinjam.');
    }
  }

  void returnItem() {
    if (!_isEmpty()) {
      String itemName = _pop();
      int index = _binarySearch(itemName);
      if (index != -1) {
        items[index].isBorrowed = false;
        print('Nama barang "$itemName" berhasil dikembalikan.');
      }
    } else {
      print('Tidak ada barang yang perlu dikembalikan.');
    }
  }

  void removeItem(String name) {
    int index = _binarySearch(name);
    if (index != -1) {
      items.removeAt(index);
      print('Nama barang "$name" telah dihapus dari program.');
    } else {
      print('Nama barang "$name" tidak ditemukan.');
    }
  }

  void sortItems() {
    if (items.isNotEmpty) {
      _mergeSort(items, 0, items.length - 1);
      print('Barang berhasil diurutkan.');
    }
  }

  void _merge(List<Item> arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    List<Item> L = List<Item>.filled(n1, Item('', false), growable: false);
    List<Item> R = List<Item>.filled(n2, Item('', false), growable: false);

    for (int i = 0; i < n1; ++i) {
      L[i] = arr[left + i];
    }
    for (int j = 0; j < n2; ++j) {
      R[j] = arr[mid + 1 + j];
    }

    int i = 0, j = 0;
    int k = left;

    while (i < n1 && j < n2) {
      if (L[i].name.compareTo(R[j].name) <= 0) {
        arr[k] = L[i];
        i++;
      } else {
        arr[k] = R[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      arr[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      arr[k] = R[j];
      j++;
      k++;
    }
  }

  void _mergeSort(List<Item> arr, int left, int right) {
    if (left < right) {
      int middle = left + ((right - left) ~/ 2);

      _mergeSort(arr, left, middle);
      _mergeSort(arr, middle + 1, right);

      _merge(arr, left, middle, right);
    }
  }

  int _binarySearch(String name) {
    int left = 0, right = items.length - 1;
    while (left <= right) {
      int middle = (left + right) ~/ 2;
      if (items[middle].name == name) {
        return middle;
      } else if (items[middle].name.compareTo(name) < 0) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }
    return -1;
  }

  void printInventory() {
    print('Inventory:');
    for (var item in items) {
      print(item);
    }
  }

  bool _isEmpty() {
    return top == -1;
  }

  bool _isFull() {
    return top == maxStack - 1;
  }

  void _push(String data) {
    if (_isFull()) {
      print("Stack overflow");
    } else {
      top = top + 1;
      borrowedItemsStack[top] = data;
    }
  }

  String _pop() {
    String data = "";
    if (_isEmpty()) {
      print("Stack underflow");
    } else {
      data = borrowedItemsStack[top];
      borrowedItemsStack[top] = "";
      top = top - 1;
    }
    return data;
  }
}

void main() {
  var inventory = Inventory(100); 

  print('========================= Menambah Data =========================');
  inventory.addItem('TendaKecil001');
  inventory.addItem('TendaKecil002');
  inventory.addItem('TendaKecil003');
  inventory.addItem('TendaBesar001');
  inventory.addItem('TendaBesar002');
  inventory.addItem('TendaBesar003');
  inventory.addItem('MatrasCamping001');
  inventory.addItem('MatrasCamping002');
  inventory.addItem('MatrasCamping003');
  inventory.addItem('KomporPortable001');
  inventory.addItem('KomporPortable002');
  inventory.addItem('LenteraCamping001');
  inventory.addItem('LenteraCamping002');

  print('========================= Menampilkan Data =========================');
  inventory.printInventory();

  print('========================= Mengurutkan Data =========================');
  inventory.sortItems();
  inventory.printInventory();

  print('========================= Meminjam Data =========================');
  inventory.borrowItem('TendaKecil001');
  inventory.borrowItem('TendaBesar001');
  inventory.borrowItem('TendaBesar001');


  print('========================= Mengembalikkan Data =========================');
  inventory.returnItem();
  inventory.returnItem(); 
  inventory.returnItem(); 

  print('========================= Menghapus Data =========================');
  inventory.removeItem('TendaBesar003');

  inventory.printInventory();

  inventory.sortItems();
  inventory.printInventory();

  var nama = 'TendaKecil002';
  var cari = inventory._binarySearch('$nama');
  if (cari != -1) {
    print('Ditemukan: ${inventory.items[cari]}');
  } else {
    print('$nama Item tidak ditemukan.');
  }

}
