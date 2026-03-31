pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool dropdownOpen: false
    property int currentSection: 0

    function toggleDropdown() {
        dropdownOpen = !dropdownOpen
    }

    function goToSection(index: int) {
        currentSection = index
    }
}
